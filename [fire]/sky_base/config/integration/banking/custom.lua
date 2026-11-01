if Sky.Config.banking ~= "custom" then return end
if not IsDuplicityVersion() then return end

-- Server-owner template: supply the selected banking resource's actual contracts.

Sky.FW.SharedAccountProvisioner = {
    probe = function(name, kind)
        -- Read only: return status, accountName/accountType, canCreate, and existing-account id/persisted/loaded.
        -- Use status = "missing" for absent accounts and "blocked" with an error for unsupported kinds.
        -- Never create an account here or replace a missing account with zero.
        error("Custom banking integration: SharedAccountProvisioner.probe is not implemented")
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    -- Return the current balance for the job/society account named `name`.
    error("Custom banking integration: GetSharedAccountBalance is not implemented")
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    -- Add `amount` and return true when the operation succeeded.
    error("Custom banking integration: AddSharedAccountBalance is not implemented")
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    -- Only remove available funds and return whether the operation succeeded.
    error("Custom banking integration: RemoveSharedAccountBalance is not implemented")
end
