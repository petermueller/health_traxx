defmodule HealthTraxx.ProcedurePolling.Supervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    procedures_with_payors = %{
      "Hip Replacement" => %{
        pumana: %{id: "0e346ba3-2b0c-463d-a3d0-91a5d32a0ade", reimbursement_amount: "39.99"},
        dcds: %{id: "hip-replacement-r-side", refund: "41.99"},
        sigma: %{id: "1009", avg_reimb: "40.19"}
      },
      "Liver Transplant" => %{
        pumana: %{id: "897d9271-370b-4a29-b4bb-1944cf0407af", reimbursement_amount: "452.65"},
        sigma: %{id: "6482", avg_reimb: "443.21"}
      },
      "Lobotomy" => %{
        dcds: %{id: "lobotomy", refund: "0.56"},
        sigma: %{id: "1375", avg_reimb: "1.06"}
      },
      "Arm Amputation" => %{
        pumana: %{id: "f94ff092-acc1-46c2-86de-300fdeec9b83", reimbursement_amount: "1.57"},
        dcds: %{id: "amputation-upper-limb-r-side", refund: "3.78"}
      },
      "Appendix Removal" => %{
        pumana: %{id: "2b392b45-7d20-42b2-a0ee-9ed5dac95cdc", reimbursement_amount: "26.98"},
        dcds: %{id: "appendicitis-recommendation", refund: "32.22"},
        sigma: %{id: "5971", avg_reimb: "2987"}
      },
      "Triple Bypass" => %{
        pumana: %{id: "9bf55346-fa25-45f1-a099-66ee41cf2188", reimbursement_amount: "111.68"},
        dcds: %{id: "heart-surgery-bypass-x-3", refund: "105.69"},
        sigma: %{id: "3246", avg_reimb: "132.54"}
      }
    }

    children =
      procedures_with_payors
      |> Enum.map(fn procedure_with_payors_and_values ->
        {HealthTraxx.ProcedurePolling.ProcedurePoller, procedure_with_payors_and_values}
      end)

    Supervisor.init(children, strategy: :one_for_one)
  end
end
