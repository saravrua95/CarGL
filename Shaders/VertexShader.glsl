
attribute vec4 a_Position;	        // in: Posición de cada vértice
attribute vec3 a_Normal;	        // in: Normal de cada vértice

uniform mat4 u_ProjectionMatrix; 	// in: Matriz Projection
uniform mat4 u_MVMatrix;	        // in: Matriz ModelView
uniform mat4 u_VMatrix;             // in: Matriz View (cámara)
uniform vec4 u_Color;		        // in: Color del objeto

uniform int  u_Luz0;                // in: Indica si la luz 0 está encedida
uniform vec4 u_Luz0_position;
uniform float u_Luz0_intensity;

uniform int  u_Luz1;
uniform vec4 u_Luz1_position;
uniform float u_Luz1_intensity;

uniform int  u_Luz2;
uniform vec4 u_Luz2_position;
uniform float u_Luz2_intensity;

varying vec4 v_Color;		        // out: Color al fragment shader


void main()
{
	float ambient = 0.15;
	float totalDiffuse = 0.0;
	float totalAttenuation = 0.0;
	int n = 15;

    vec3 P = vec3(u_MVMatrix * a_Position);	            // Posición del vértice
	vec3 N = vec3(u_MVMatrix * vec4(a_Normal, 0.0));    // Normal del vértice
	vec4 position={ u_VMatrix[3][0], u_VMatrix[3][1], u_VMatrix[3][2], u_VMatrix[3][0]};
	vec3 V=normalize(vec3(u_VMatrix*position*vec4(0.0,0.0,0.0,1.0))-P);

	// Light 0
    vec4 LightPos0 = u_VMatrix*u_Luz0_position;
	float d0 = length(LightPos0.xyz - P);
	vec3  l0 = normalize(LightPos0.xyz - P);
	float diffuse0 = 0.0;
	float attenuation0 = 0.0;
	float specular0 = 0.0;

	// Light 1
    vec4 LightPos1 = u_VMatrix*u_Luz1_position;
	float d1 = length(LightPos1.xyz - P);
	vec3  l1 = normalize(LightPos1.xyz - P);
	float diffuse1 = 0.0;
	float attenuation1 = 0.0;
	float specular1 = 0.0;

	// Light 2
    vec4 LightPos2 = u_VMatrix*u_Luz2_position;
	float d2 = length(LightPos2.xyz - P);
	vec3  l2 = normalize(LightPos2.xyz - P);
	float diffuse2 = 0.0;
	float attenuation2 = 0.0;
	float specular2 = 0.0;


	if (u_Luz0>0) {
        diffuse0 = max(dot(N, l0), 0.0);
        attenuation0 = 80.0/(0.25+(0.01*d0)+(0.003*d0*d0));
        specular0 =  2*attenuation0*pow(max(0.0, dot(reflect(l0, N), V)), n);
        diffuse0 = (diffuse0 * attenuation0 * u_Luz0_intensity) + specular0;
	}

	if (u_Luz1>0) {
        diffuse1 = max(dot(N, l1), 0.0);
        attenuation1 = 80.0/(0.25+(0.01*d1)+(0.003*d1*d1));
        specular1 = 2*attenuation1*pow(max(0.0, dot(reflect(l1, N), V)), n);
        diffuse1 = (diffuse1 * attenuation1 * u_Luz1_intensity) + specular1;
	}

	if (u_Luz2>0) {
        diffuse2 = max(dot(N, l2), 0.0);
        attenuation2 = 80.0/(0.25+(0.01*d2)+(0.003*d2*d2));
        specular2 = 2*attenuation2*pow(max(0.0, dot(reflect(l2, N), V)), n);
        diffuse2 = (diffuse2 * attenuation2 * u_Luz2_intensity) + specular2;
	}

	totalDiffuse = diffuse0 + diffuse1 + diffuse2;
	v_Color = u_Color * (ambient + totalDiffuse);
	gl_Position = u_ProjectionMatrix * vec4(P, 1.0);
}
