#version 430 core

uniform sampler2D texture;

//[FS In ]=============================================
in VS_OUT
{
	vec3 N;
	vec3 L;
	vec3 V;
	vec2 texcoord;
} fs_in;


//[FS In Uniform]======================================
// ����
layout (std140, binding = 2) uniform phong_mat_block
{
	vec3 specular_albedo;
	float specular_power;
};


//[Material Routine]===================================
// type ����
subroutine vec4 SubMaterialShading();

// �Լ� ����
layout (index = 1)
subroutine(SubMaterialShading)
vec4 funcBasic()
{
	return vec4(0.5, 0.5, 0.5, 1);
}

layout (index = 2)
subroutine(SubMaterialShading)
vec4 funcDiffuse()
{
	return texture2D(texture, fs_in.texcoord);
}

layout (index = 3)
subroutine(SubMaterialShading)
vec4 funcPhong()
{
	// �Է� N, L, V ���͸� ����ȭ
	vec3 N = normalize(fs_in.N);
	vec3 L = normalize(fs_in.L);
	vec3 V = normalize(fs_in.V);

	// ���� ��ǥ �󿡼� R�� ���
	vec3 R = reflect(-L, N);

	//
	vec4 diffuse_albedo = texture2D(texture, fs_in.texcoord);

	// �� �����׸�Ʈ���� diffuse �� specular ��� ��� // todo : diffuse min �� ������ ����!
	vec3 diffuse = max(dot(N, L), 0.8) * diffuse_albedo.xyz;
	vec3 specular = pow(max(dot(R, V), 0.0), specular_power) * specular_albedo;

	// �����ӹ��ۿ� ���� ���� ���
	return vec4(diffuse + specular, diffuse_albedo.w);
}

// �����ƾ ������ ����
subroutine uniform SubMaterialShading material_Routine;

//[Entry]==============================================
void main(void)
{
	gl_FragColor = material_Routine();
}