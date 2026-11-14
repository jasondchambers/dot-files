// Kitty-style cursor trail for Ghostty (needs Ghostty 1.2+ for the cursor uniforms).
//
// When the cursor jumps, a tapered smear is drawn from the old position to the
// new one; its tail catches up to the cursor and fades out over DURATION.
// Small moves (e.g. typing) are ignored so the trail only shows on real jumps.

const float DURATION  = 0.25; // seconds for the tail to catch up
const float OPACITY   = 0.8;  // trail opacity at the head
const float MIN_CELLS = 1.5;  // ignore moves shorter than this many cursor widths
const float TAPER     = 0.35; // tail thickness relative to the cursor

float sdBox(vec2 p, vec2 halfSize) {
    vec2 d = abs(p) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float easeOutCubic(float x) {
    return 1.0 - pow(1.0 - x, 3.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord / iResolution.xy);

    // Cursor uniforms are (left, top, width, height) in pixels, y pointing up.
    vec2 curHalf  = iCurrentCursor.zw * 0.5;
    vec2 cur      = iCurrentCursor.xy + vec2(curHalf.x, -curHalf.y);
    vec2 prevHalf = iPreviousCursor.zw * 0.5;
    vec2 prev     = iPreviousCursor.xy + vec2(prevHalf.x, -prevHalf.y);

    float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    if (progress >= 1.0) return;
    if (length(cur - prev) < MIN_CELLS * max(iCurrentCursor.z, 1.0)) return;

    // Leave the cursor cell itself to Ghostty's own cursor rendering.
    if (sdBox(fragCoord - cur, curHalf) <= 0.0) return;

    // The tail eases from the old position toward the cursor.
    vec2 tail = mix(prev, cur, easeOutCubic(progress));
    vec2 seg = cur - tail;
    float t = clamp(dot(fragCoord - tail, seg) / max(dot(seg, seg), 1e-4), 0.0, 1.0);

    // Box swept along tail -> cursor, thinning toward the tail.
    vec2 halfSize = curHalf * mix(TAPER, 1.0, t);
    float d = sdBox(fragCoord - (tail + seg * t), halfSize);

    float alpha = (1.0 - smoothstep(-1.0, 1.0, d)) * OPACITY * (1.0 - progress) * mix(0.3, 1.0, t);
    fragColor.rgb = mix(fragColor.rgb, iCurrentCursorColor.rgb, alpha);
}
