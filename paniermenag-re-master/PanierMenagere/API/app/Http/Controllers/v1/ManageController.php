<?php

namespace App\Http\Controllers\v1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Manage;
use Validator;
use DB;

class ManageController extends Controller
{
    public function save(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'app_close' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.',
                $validator->errors(),
                'status' => 500
            ];
            return response()->json($response, 404);
        }

        $data = Manage::create($request->all());
        if (is_null($data)) {
            $response = [
                'data' => $data,
                'message' => 'error',
                'status' => 500,
            ];
            return response()->json($response, 200);
        }
        $response = [
            'data' => $data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getById(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'id' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.',
                $validator->errors(),
                'status' => 500
            ];
            return response()->json($response, 404);
        }

        $data = Manage::find($request->id);

        if (is_null($data)) {
            $response = [
                'success' => false,
                'message' => 'Data not found.',
                'status' => 404
            ];
            return response()->json($response, 404);
        }

        $response = [
            'data' => $data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function update(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'id' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.',
                $validator->errors(),
                'status' => 500
            ];
            return response()->json($response, 404);
        }
        $data = Manage::find($request->id)->update($request->all());

        if (is_null($data)) {
            $response = [
                'success' => false,
                'message' => 'Data not found.',
                'status' => 404
            ];
            return response()->json($response, 404);
        }
        $response = [
            'data' => $data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function delete(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'id' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.',
                $validator->errors(),
                'status' => 500
            ];
            return response()->json($response, 404);
        }
        $data = Manage::find($request->id);
        if ($data) {
            $data->delete();
            $response = [
                'data' => $data,
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);
        }
        $response = [
            'success' => false,
            'message' => 'Data not found.',
            'status' => 404
        ];
        return response()->json($response, 404);
    }

    public function getAll()
    {
        $data = Manage::all();
        if (is_null($data)) {
            $response = [
                'success' => false,
                'message' => 'Data not found.',
                'status' => 404
            ];
            return response()->json($response, 404);
        }

        $response = [
            'data' => $data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function importData(Request $request)
    {
        $request->validate([
            "csv_file" => "required",
        ]);
        $file = $request->file("csv_file");
        $csvData = file_get_contents($file);
        $rows = array_map("str_getcsv", explode("\n", $csvData));
        $header = array_shift($rows);
        foreach ($rows as $row) {
            if (isset($row[0])) {
                if ($row[0] != "") {

                    if (count($header) == count($row)) {
                        $row = array_combine($header, $row);
                        $insertInfo = array(
                            'id' => $row['id'],
                            'app_close' => $row['app_close'],
                            'message' => $row['message'],
                            'date_time' => $row['date_time'],
                        );
                        $checkLead = Manage::where("id", "=", $row["id"])->first();
                        if (!is_null($checkLead)) {
                            DB::table('manage')->where("id", "=", $row["id"])->update($insertInfo);
                        } else {
                            DB::table('manage')->insert($insertInfo);
                        }
                    }
                }
            }
        }
        $response = [
            'data' => 'Done',
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }
}
