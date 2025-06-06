// A shader that simply smoothes the pixels using a Gaussian kernel.
// Can be nice to compare with.

fn aaShader(
    tex: texture_2d<f32>,
    smp: sampler,
    texCoord: vec2<f32>,
    scaleFactor: f32,
) -> vec4<f32> {

    let resolution = vec2<f32>(textureDimensions(tex));

    var color = vec3<f32>(0.0, 0.0, 0.0);

    let kernel = vec4<f32>(0.53, 0.22, 0.015, 0.00018); // Gaussian sigma 0.75
    let sze = 3;

    let dx = 1.0 / resolution.x;
    let dy = 1.0 / resolution.y;

    for (var y = -sze; y <= sze; y = y + 1) {
        for (var x = -sze; x <= sze; x = x + 1) {
            let kx = kernel[abs(x)];
            let ky = kernel[abs(y)];
            let k = kx * ky;

            let offset = vec2<f32>(f32(x) * dx, f32(y) * dy);
            let sample = textureSample(tex, smp, texCoord + offset).rgb;
            color = color + sample * k;
        }
    }

    return vec4<f32>(color, 1.0);
}
