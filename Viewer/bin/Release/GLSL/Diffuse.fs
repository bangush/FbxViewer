#version 430 core

// ����
uniform sampler2D texture;

// ���ؽ� ���̴��κ����� �Է�
in VS_OUT
{
	vec2 texcoord;
} fs_in;

// �����׸�Ʈ ���̴��� ������
void main(void)
{
	gl_FragColor = texture2D(texture, fs_in.texcoord);
}