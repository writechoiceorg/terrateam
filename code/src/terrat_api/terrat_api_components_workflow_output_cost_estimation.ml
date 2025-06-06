module Outputs = struct
  type t =
    | Output_text of Terrat_api_components_output_text.t
    | Output_cost_estimation of Terrat_api_components_output_cost_estimation.t
  [@@deriving show, eq]

  let of_yojson =
    Json_schema.one_of
      (let open CCResult in
       [
         (fun v -> map (fun v -> Output_text v) (Terrat_api_components_output_text.of_yojson v));
         (fun v ->
           map
             (fun v -> Output_cost_estimation v)
             (Terrat_api_components_output_cost_estimation.of_yojson v));
       ])

  let to_yojson = function
    | Output_text v -> Terrat_api_components_output_text.to_yojson v
    | Output_cost_estimation v -> Terrat_api_components_output_cost_estimation.to_yojson v
end

module Workflow_step = struct
  module Type = struct
    let t_of_yojson = function
      | `String "cost-estimation" -> Ok "cost-estimation"
      | json -> Error ("Unknown value: " ^ Yojson.Safe.pretty_to_string json)

    type t = (string[@of_yojson t_of_yojson])
    [@@deriving yojson { strict = false; meta = true }, show, eq]
  end

  type t = { type_ : Type.t [@key "type"] }
  [@@deriving yojson { strict = false; meta = true }, show, eq]
end

type t = {
  outputs : Outputs.t;
  success : bool;
  workflow_step : Workflow_step.t;
}
[@@deriving yojson { strict = false; meta = true }, show, eq]
