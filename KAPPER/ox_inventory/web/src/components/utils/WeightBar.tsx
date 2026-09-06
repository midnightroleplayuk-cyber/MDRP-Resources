import React, { useMemo } from 'react';

const colorChannelMixer = (colorChannelA: number, colorChannelB: number, amountToMix: number) => {
  let channelA = colorChannelA * amountToMix;
  let channelB = colorChannelB * (1 - amountToMix);
  return channelA + channelB;
};

const colorMixer = (rgbA: number[], rgbB: number[], amountToMix: number) => {
  let r = colorChannelMixer(rgbA[0], rgbB[0], amountToMix);
  let g = colorChannelMixer(rgbA[1], rgbB[1], amountToMix);
  let b = colorChannelMixer(rgbA[2], rgbB[2], amountToMix);
  return `rgb(${r}, ${g}, ${b})`;
};

const COLORS = {
  // Durability semantics keep a red→orange→green ramp.
  primaryColor: [231, 76, 60], // Red (Pomegranate)
  secondColor: [39, 174, 96], // Green (Nephritis)
  accentColor: [211, 84, 0], // Orange (Orange)
};

/* Weight follows the BRAND colour (css var, so it retints live with the
   settings panel); it warms to amber past 75% and pulses red past 92%. */
const WeightBar: React.FC<{ percent: number; durability?: boolean }> = ({ percent, durability }) => {
  const durabilityColor = useMemo(
    () =>
      durability
        ? percent < 50
          ? colorMixer(COLORS.accentColor, COLORS.primaryColor, percent / 100)
          : colorMixer(COLORS.secondColor, COLORS.accentColor, percent / 100)
        : undefined,
    [durability, percent]
  );

  if (durability) {
    return (
      <div className="durability-bar">
        <div
          className="durability-bar-fill"
          style={{
            visibility: percent > 0 ? 'visible' : 'hidden',
            width: `${percent}%`,
            backgroundColor: durabilityColor,
          }}
        ></div>
      </div>
    );
  }

  const state = percent >= 92 ? ' weight-bar-fill-danger' : percent >= 75 ? ' weight-bar-fill-hot' : '';

  return (
    <div className="weight-bar">
      <div
        className={`weight-bar-fill${state}`}
        style={{
          visibility: percent > 0 ? 'visible' : 'hidden',
          width: `${percent}%`,
        }}
      ></div>
    </div>
  );
};
export default WeightBar;
