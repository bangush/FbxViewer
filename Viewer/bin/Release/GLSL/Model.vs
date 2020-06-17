#version 430 core

//[VS In Per Vertex]===================================
layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec2 texcoord;
layout (location = 3) in int bone_id;


//[VS Out]=============================================
out VS_OUT
{
	vec3 N;
	vec3 L;
	vec3 V;
	vec2 texcoord;
} vs_out;


//[VS In Uniform]======================================
// ���� uniform buffer object
layout (std140, binding = 0) uniform cam_trans_block
{
	mat4 view_matrix;
	mat4 proj_matrix;
};

// ��
layout (std140, binding = 1) uniform model_block
{
	mat4 model_matrix;
};

layout (location = 13) uniform mat4[200] bone_matrices;

// ����
layout (location = 7) uniform vec3 light_dir;



//[Animation Routine]==================================
struct AnimatedVertex
{
	vec4 position;
	vec4 normal;
};

// type ����
subroutine AnimatedVertex SubAnimation();

// �Լ� ����
layout (index = 1)
subroutine(SubAnimation)
AnimatedVertex funcAnimated()
{
	AnimatedVertex v;
	v.position = vec4(position, 1.0) * bone_matrices[bone_id];
	v.normal = vec4(normal, 0.0) * bone_matrices[bone_id];

	return v;
}

layout (index = 2)
subroutine(SubAnimation)
AnimatedVertex funcDontAnimated()
{
	AnimatedVertex v;
	v.position = vec4(position, 1.0);
	v.normal = vec4(normal, 0.0);
	return v;
}

// �����ƾ ������ ����
subroutine uniform SubAnimation animated_Routine;


//[Entry]==============================================
void main(void)
{
	// skinned animation
	AnimatedVertex av = animated_Routine();

	mat4 mv_matrix = view_matrix * model_matrix;

	// �� ���� ��ǥ ���
	vec4 P = mv_matrix * av.position;

	// �� ���� �븻 ���
	vs_out.N = mat3(mv_matrix) * av.normal.xyz;

	// ����Ʈ ���� ���(���� ����Ʈ) // vs_out.L = light_pos - P.xyz; // ���� ����Ʈ
	vs_out.L = normalize(light_dir);

	// �� ���� ���
	vs_out.V = -P.xyz;

	// UV ��ǥ
	vs_out.texcoord = texcoord;

	// �� ���ؽ��� ���� ���� ��ġ ���
	gl_Position = proj_matrix * P;
}