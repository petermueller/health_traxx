defmodule HealthTraxx.ProcedurePolling.Loader do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_arg) do
    # TODO - replace with loading from data store and change as we get timestamps and such

    # TODO - add some sort of re-checking logic. Maybe a spawn with a delay. Don't know, but may need a "check for new procedure config" ability

    procedures_with_payors = %{
      "Hip Replacement" => %{
        pumana: %{id: "0e346ba3-2b0c-463d-a3d0-91a5d32a0ade", reimbursement_amount: "39.99"},
        dcds: %{id: "hip-replacement-r-side", refund: "41.99"},
        sigma: %{id: "1009", avg_reimb: "40.19"}
      },
      "Liver Transplant" => %{
        pumana: %{id: "897d9271-370b-4a29-b4bb-1944cf0407af", reimbursement_amount: "452.65"},
        dcds: %{id: "liver-transplant-no-complications", refund: :not_reimbursed},
        sigma: %{id: "6482", avg_reimb: "443.21"}
      },
      "Lobotomy" => %{
        pumana: %{
          id: "cccc7d8f-ed9a-4729-b595-c4fd405ee66b",
          reimbursement_amount: :not_reimbursed
        },
        dcds: %{id: "lobotomy", refund: "0.56"},
        sigma: %{id: "1375", avg_reimb: "1.06"}
      },
      "Arm Amputation" => %{
        pumana: %{id: "f94ff092-acc1-46c2-86de-300fdeec9b83", reimbursement_amount: "1.57"},
        dcds: %{id: "amputation-upper-limb-r-side", refund: "3.78"},
        sigma: %{id: "8424", avg_reimb: :not_reimbursed}
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

    # IO.inspect(procedures_with_payors)

    {:ok, procedures_with_payors}
  end
end
