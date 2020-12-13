HUD = {}

--- Sets blurriness or something `Citizen.InvokeNative(0xBA3D65906822BED5, 1, 1, 0.0, 0.0, 0.0, 100.0)`
function HUD:Fov(p1, p2, nearPlaneOut, nearPlaneIn, farPlaneOut, farPlaneIn)
    Citizen.InvokeNative(0xBA3D65906822BED5, p1, p2, nearPlaneOut + 0.0, nearPlaneIn + 0.0, farPlaneOut + 0.0, farPlaneIn + 0.0)
end
