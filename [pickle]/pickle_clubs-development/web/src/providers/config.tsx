import React, { createContext, useContext, useState, ReactNode } from 'react';
import { useNuiEvent } from './nui/useNui';


export type Config = {
    name: string;
    identifier: string;
    disableWithdraw: boolean;
    evidenceEnabled: boolean;
    bailAndBounty: boolean;
    permissions: {
        name: string;
    }[];
    imageDirectory?: string;
    imageExtension?: string;
    locale?: Record<string, string>;
    countryCode?: string;
    currency?: string;
    items: {
        [key: string]: {
            label: string;
        };
    };
    policeArmory: {
        name: string;
    }[];
    policeGarage: {
        label: string;
        model: number;
    }[];
    garageTypes: {
        [key: string]: {
            label: string;
        };
    };
    locationTypes: {
        [key: string]: {
            locations: string[];
            settings: string[];
        };
    };
    peds: {
        label: string;
        model: string;
    }[];
    jobs: {
        [key: string]: {
            label: string;
            maxLevel: number;
        };
    };
}

interface ConfigContextProps {
    config: Config;
    setConfig: (config: Config) => void;
}

const ConfigContext = createContext<ConfigContextProps | undefined>(undefined);

export const ConfigProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
    const [config, setConfig] = useState<Config>({
        disableWithdraw: false,
        bailAndBounty: false,
        imageExtension: "png",
        locale: {
        },
        imageDirectory: undefined,
        name: "Unknown",
        identifier: "ERR_NO_IDENTIFIER",
        currency: "GBP",
        countryCode: "en-GB",
        permissions: [],
        evidenceEnabled: true,
        items: {
            "rifle": {
                label: "Rifle"
            },
            "pistol": {
                label: "Pistol"
            },
            "smg": {
                label: "SMG"
            },
            "shotgun": {
                label: "Shotgun"
            },
            "sniper": {
                label: "Sniper"
            },
            "heavy": {
                label: "Heavy"
            },
            "handgun": {
                label: "Handgun"
            },
            "knife": {
                label: "Knife"
            },
            "flashlight": {
                label: "Flashlight"
            },
            "binoculars": {
                label: "Binoculars"
            },
            "radio": {
                label: "Radio"
            },
            "paper": {
                label: "Taser"
            },
        },
        policeArmory: [
            {
                name: "rifle",
            },
            {
                name: "pistol",
            },
            {
                name: "smg",
            },
            {
                name: "shotgun",
            },
            {
                name: "sniper",
            },
            {
                name: "heavy",
            },
            {
                name: "handgun",
            },
            {
                name: "knife",
            },
            {
                name: "flashlight",
            },
            {
                name: "binoculars",
            },
            {
                name: "radio",
            },
            {
                name: "paper",
            },
        ],
        policeGarage: [
            {
                label: "Crown Victoria",
                model: -12300341,
            },
            {
                label: "Police Interceptor",
                model: -12300342,
            },
            {
                label: "Police Interceptor Utility",
                model: -12300343,
            },
            {
                label: "Police Interceptor Utility",
                model: -12300344,
            },
        ],
        garageTypes: {
            "ERROR": {
                label: "ERROR",
            },
        },
        peds: [
            {
                label: "Male Officer #1",
                model: "s_m_m_doctor_01",
            },
            {
                label: "Female Officer #1",
                model: "s_f_y_cop_01",
            },
        ],
        locationTypes: {
            "front_desk": {
                locations: [],
                settings: ["ped"]
            },
            "armory": {
                locations: [],
                settings: ["ped"],
            },
            "garage": {
                locations: ["garage_spawn"],
                settings: ["ped"],
            },
        },
        jobs: {
        },
    });
    useNuiEvent('setConfig', (data) => {
        setConfig({ ...config, ...data.config });
    });
    return (
        <ConfigContext.Provider value={{ config, setConfig }}>
            {children}
        </ConfigContext.Provider>
    );
};

export const useConfig = (): ConfigContextProps => {
    const context = useContext(ConfigContext);
    if (!context) {
        throw new Error('useConfig must be used within a ConfigProvider');
    }
    return context;
};