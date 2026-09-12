```lua
	['plt_medkit'] = {
		label = 'Medkit',
		weight = 500,
		stack = true,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'Standard medical kit for treatment.',
	},

	['plt_bandage'] = {
		label = 'Bandage',
		weight = 100,
		stack = true,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'A basic bandage to stop bleeding.',
	},

	['plt_painkillers'] = {
		label = 'Painkillers',
		weight = 50,
		stack = true,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'Helps reduce pain and stabilize patients.',
	},

	['plt_painkillers_adv'] = {
		label = 'Advanced Painkillers',
		weight = 50,
		stack = true,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'A stronger prescription-only pain medication.',
	},

	['plt_antibiotics'] = {
		label = 'Antibiotics',
		weight = 50,
		stack = true,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'Used to treat infections and more serious trauma.',
	},

	['plt_surgical_kit'] = {
		label = 'Surgical Kit',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Professional tools for extracting bullets and deep surgery.',
	},

	['plt_stretcher'] = {
		label = 'Stretcher',
		weight = 5000,
		stack = false,
		close = true,
		description = 'Used to transport patients safely.',
	},

	['plt_oxygen_mask'] = {
		label = 'Oxygen Mask',
		weight = 300,
		stack = true,
		close = true,
		description = 'Helps patients breathe in critical conditions.',
	},

	['plt_surgical_scissors'] = {
		label = 'Surgical Scissors',
		weight = 200,
		stack = true,
		close = true,
		description = 'Used to cut through clothing during emergencies.',
	},

	['plt_radio'] = {
		label = 'Radio',
		weight = 200,
		stack = false,
		close = true,
		description = 'Communication device for emergency services.',
	},

	['plt_medical_bag'] = {
		label = 'Medical Bag',
		weight = 2000,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_medical_bag' },
		description = 'A portable bag containing medical supplies with its own inventory.',
	},

	['plt_bp_monitor'] = {
		label = 'BP Monitor',
		weight = 500,
		stack = true,
		close = true,
		description = 'Blood pressure monitor used for vitals check.',
	},

	['plt_flashlight'] = {
		label = 'Flashlight',
		weight = 500,
		stack = false,
		close = true,
		description = 'High-powered flashlight for low-light conditions.',
	},

	['plt_fireextinguisher'] = {
		label = 'Fire Extinguisher',
		weight = 2000,
		stack = false,
		close = true,
		description = 'Used to put out small fires.',
	},

	['plt_prescription'] = {
		label = 'Medical Prescription',
		weight = 50,
		stack = true,
		close = true,
		description = 'An official document from a doctor authorizing specific medication.',
	},

	['iak_wheelchair'] = {
		label = 'Wheelchair',
		weight = 5000,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'A mobility assistance device for patients with leg injuries.',
	},

	['plt_walking_stick'] = {
		label = 'Walking Stick',
		weight = 800,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'Use to toggle a limping movement effect.',
	},

	['plt_cane'] = {
		label = 'Cane',
		weight = 800,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'Use to toggle a limping movement effect.',
	},

	['plt_crutches'] = {
		label = 'Crutches',
		weight = 1200,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'Use to toggle a limping movement effect.',
	},

	['plt_ems_certificate'] = {
		label = 'EMS Certificate',
		weight = 50,
		stack = false,
		close = true,
		description = 'Official EMS medical certificate signed by staff.',
        client = {
            image = 'prescription.png',
        }
	},

	['as_xray_clipboard_01'] = {
		label = 'X-Ray Clipboard #01',
		weight = 200,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_xray_clipboard' },
		description = 'Fracture-only X-ray print mounted on a clipboard.',
	},

	['as_xray_clipboard_02'] = {
		label = 'X-Ray Clipboard #02',
		weight = 200,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_xray_clipboard' },
		description = 'Fracture-only X-ray print mounted on a clipboard.',
	},

	['as_xray_clipboard_03'] = {
		label = 'X-Ray Clipboard #03',
		weight = 200,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_xray_clipboard' },
		description = 'Fracture-only X-ray print mounted on a clipboard.',
	},

	['as_xray_clipboard_04'] = {
		label = 'X-Ray Clipboard #04',
		weight = 200,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_xray_clipboard' },
		description = 'Fracture-only X-ray print mounted on a clipboard.',
	},
```