#version 430 core

//
layout (location = 0) in vec3 position;
layout (location = 3) in int bone_id;

//
layout (location = 12) uniform mat4 mvp_matrix;
layout (location = 13) uniform mat4[200] bone_matrices;

//
// type ����
subroutine vec4 SubAnimation();

// �Լ� ����
layout (index = 1)
subroutine(SubAnimation)
vec4 funcAnimated()
{
	return vec4(position, 1.0) * bone_matrices[bone_id];
}

layout (index = 2)
subroutine(SubAnimation)
vec4 funcDontAnimated()
{
	return vec4(position, 1.0);
}

// �����ƾ ������ ����
subroutine uniform SubAnimation animated_Routine;

//
void main(void)
{
	gl_Position = mvp_matrix * animated_Routine();
}