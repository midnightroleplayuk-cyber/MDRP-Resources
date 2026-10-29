import React from "react";

type RangeControlProps = {
	value: number;
	min: number;
	max: number;
	step?: number;
	onChange: (value: number) => void;
	orientation?: "horizontal" | "vertical";
	barStyle?: React.CSSProperties;
	ariaLabel?: string;
	disabled?: boolean;
	showVu?: boolean;
	vuLevel?: number; // 0..1
	vuMeterStyle?: React.CSSProperties;
	label?: React.ReactNode;
	valueText?: React.ReactNode;
	className?: string;
	style?: React.CSSProperties;
};

export function VuMeter({ meterStyle, level }: { meterStyle?: React.CSSProperties, level: number }) {
	const segments = 12;
	const lit = Math.max(0, Math.min(segments, Math.round(level * segments)));
	const segs = [];
	for (let i = 0; i < segments; i++) {
		const idxFromBottom = i + 1;
		const on = idxFromBottom <= lit;
		let color = "#18a058";
		const frac = idxFromBottom / segments;
		if (frac >= 0.85) color = "#d64545";
		else if (frac >= 0.65) color = "#c8a43b";
		segs.push(
			<div
				key={i}
				className="vuSeg"
				style={{ background: on ? color : undefined }}
			/>
		);
	}
	return (
		<div className="vu" style={meterStyle}>
			{segs}
		</div>
	);
}

export default function RangeControl(props: RangeControlProps) {
	const {
		value,
		min,
		max,
		step = 1,
		onChange,
		orientation = "horizontal",
		barStyle,
		ariaLabel,
		disabled,
		showVu = false,
		vuLevel = 0,
		vuMeterStyle,
		label,
		valueText,
		className,
		style,
	} = props;

	const inputClass = `${orientation === "vertical" ? "range vRange" : "range"}${className ? ` ${className}` : ""}`;

	if (orientation === "vertical") {
		return (
			<div style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 6, height: "100%", ...style }}>
				{label != null ? <span className="text-xs font-semibold whitespace-nowrap">{label}</span> : null}
				<div style={{ display: "flex", position: "relative", alignItems: "center", gap: 6, height: "100%" }}>
		            <div className="absolute w-28 top-[50%] translate-y-[-50%] pointer-events-none select-none" style={{ left: showVu ? "-65px" : "-52.5px", ...barStyle }}>
		                <input
		                    className={`${inputClass} pointer-events-auto`}
							draggable={false}
		                    type="range"
		                    min={min}
		                    max={max}
		                    step={step}
		                    value={value}
		                    onChange={(e) => onChange(Number(e.target.value))}
		                    aria-label={ariaLabel}
		                    disabled={disabled}
		                />
		            </div>
		            <div className="absolute h-28 top-[50%] translate-y-[-50%] right-[-16px]" style={vuMeterStyle}>
		                {showVu ? <VuMeter level={vuLevel} /> : null}
		            </div>
				</div>
				{valueText != null ? <span className="text-xs whitespace-nowrap">{valueText}</span> : null}
			</div>
	    );
	}

	return (
		<div style={{ display: "flex", alignItems: "center", gap: 6, height: "100%", ...style }}>
			{label != null ? <span>{label}</span> : null}
			<input
				className={inputClass}
				type="range"
				min={min}
				max={max}
				step={step}
				value={value}
				onChange={(e) => onChange(Number(e.target.value))}
				aria-label={ariaLabel}
				disabled={disabled}
			/>
			{showVu ? <VuMeter level={vuLevel} /> : null}
			{valueText != null ? <span>{valueText}</span> : null}
		</div>
	);
}

