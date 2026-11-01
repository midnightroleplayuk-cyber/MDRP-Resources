-- MAKE SURE TO READ THE DOCS BEFORE EDITING THIS FILE, PLEASE AND THANK YOU :))

local paper_colors = { -- all paper colors
    "#ffffff",
    "#f8f9fa",
    "#f1f3f5",
    "#fff9db",
    "#fceeac",
    "#fdf5e6",
    "#e6fcf5",
    "#e3fafc",
    "#f3f0ff",
    "#fff0f6",
}

local all_colors = { -- other colors like text, highlight and row background
    "#ffffff",
    "#25262b",
    "#868e96",
    "#fa5252",
    "#e64980",
    "#be4bdb",
    "#7950f2",
    "#4c6ef5",
    "#228be6",
    "#15aabf",
    "#12b886",
    "#40c057",
    "#82c91e",
    "#fab005",
    "#fd7e14",
}

local allCertificates = { -- documents certificates
    ['police'] = {
        grade = 1, -- min rank allowed to certify a document
        header = "LOS SANTOS POLICE DEPARTMENT",
        subheader = "Certified LSPD Document",
        logo = "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/lspd.png"
    },
    ['ambulance'] = {
        grade = 1, -- min rank allowed to certify a document
        header = "STATE OF SAN ANDREAS",
        subheader = "Certified Medical Evaluation",
        logo = "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/medical.png"
    },
}

function getCertificate()
    local job = PlayerJob and PlayerJob.name
    local grade = getGrade()
    local hasCertificate = allCertificates[job] or false
    local result = nil
    dbug('getCertificate(certificate?, jobName, jobGrade)', hasCertificate and "yes" or "no", job, grade)
    if hasCertificate then
        if hasCertificate["grade"] and (hasCertificate["grade"] <= grade) then
            result = hasCertificate
        else
            dbug("Player doesn't meeth the needed grade for job certificate stamp (neededGrade, currentGrade)", hasCertificate["grade"], grade)
        end
    end
    return result
end

function getPaperColors()
    return paper_colors
end

function getColors()
    return all_colors
end