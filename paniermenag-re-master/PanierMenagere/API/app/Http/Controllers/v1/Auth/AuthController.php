<?php

namespace App\Http\Controllers\v1\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Requests\Auth\LoginRequest;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;
use PHPOpenSourceSaver\JWTAuth\Exceptions\TokenExpiredException;
use PHPOpenSourceSaver\JWTAuth\Exceptions\TokenInvalidException;
use PHPOpenSourceSaver\JWTAuth\Exceptions\JWTException;
use App\Models\User;
use App\Models\Otp;
use App\Models\General;
use App\Models\Drivers;
use App\Models\Settings;
use Carbon\Carbon;
use Illuminate\Support\Facades\Mail;
use Illuminate\Hashing\BcryptHasher;
use App\Http\Resources\User as UserResource;
use Validator;
use Config;
use DB;

class AuthController extends Controller
{
    public function login(LoginRequest $request)
    {
        $user = User::where('email', $request->email)->first();

        if (!$user)
            return response()->json(['error' => 'User not found.'], 500);

        // Account Validation
        if (!(new BcryptHasher)->check($request->input('password'), $user->password)) {

            return response()->json(['error' => 'Email or password is incorrect. Authentication failed.'], 401);
        }

        // Login Attempt
        $credentials = $request->only('email', 'password');

        try {

            JWTAuth::factory()->setTTL(40320); // Expired Time 28days

            if (!$token = JWTAuth::attempt($credentials, ['exp' => Carbon::now()->addDays(28)->timestamp])) {

                return response()->json(['error' => 'invalid_credentials'], 401);

            }
        } catch (JWTException $e) {

            return response()->json(['error' => 'could_not_create_token'], 500);

        }
        return response()->json(['user' => $user, 'token' => $token, 'status' => 200], 200);
    }

    public function loginDrivers(LoginRequest $request)
    {
        Config::set('auth.providers.driver.model', \App\Models\Drivers::class);
        $user = Drivers::where('email', $request->email)->first();
        if (!$user)
            return response()->json(['error' => 'User not found.'], 500);

        // Account Validation
        if (!(new BcryptHasher)->check($request->input('password'), $user->password)) {

            return response()->json(['error' => 'Email or password is incorrect. Authentication failed.'], 401);
        }

        // Login Attempt
        $credentials = $request->only('email', 'password');

        try {

            JWTAuth::factory()->setTTL(40320); // Expired Time 28days


            if (!$token = JWTAuth::fromUser($user, ['exp' => Carbon::now()->addDays(28)->timestamp])) {

                return response()->json(['error' => 'invalid_credentials', 'token' => $credentials], 401);

            }
        } catch (JWTException $e) {

            return response()->json(['error' => 'could_not_create_token'], 500);

        }
        return response()->json(['user' => $user, 'token' => $token, 'status' => 200], 200);
    }

    public function adminLogin(Request $request)
    {
        $user = User::where('email', $request->email)->first();

        if (!$user)
            return response()->json(['error' => 'User not found.'], 500);

        // Account Validation
        if (!(new BcryptHasher)->check($request->input('password'), $user->password)) {

            return response()->json(['error' => 'Email or password is incorrect. Authentication failed.'], 401);
        }

        if ($user->type != 'admin') {
            return response()->json(['error' => 'access denied'], 401);
        }
        // Login Attempt
        $credentials = $request->only('email', 'password');

        try {

            JWTAuth::factory()->setTTL(40320); // Expired Time 28days

            if (!$token = JWTAuth::attempt($credentials, ['exp' => Carbon::now()->addDays(28)->timestamp])) {

                return response()->json(['error' => 'invalid_credentials'], 401);

            }
        } catch (JWTException $e) {

            return response()->json(['error' => 'could_not_create_token'], 500);

        }
        return response()->json(['user' => $user, 'token' => $token, 'status' => 200], 200);
    }

    public function loginWithPhonePassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mobile' => 'required',
            'country_code' => 'required',
            'password' => 'required'
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
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];

        $user = User::where($matchThese)->first();

        if (!$user)
            return response()->json(['error' => 'User not found.'], 500);

        // Account Validation
        if (!(new BcryptHasher)->check($request->input('password'), $user->password)) {

            return response()->json(['error' => 'Phone Number or password is incorrect. Authentication failed.'], 401);
        }

        // Login Attempt
        $credentials = $request->only('country_code', 'mobile', 'password');

        try {

            JWTAuth::factory()->setTTL(40320); // Expired Time 28days

            if (!$token = JWTAuth::attempt($credentials, ['exp' => Carbon::now()->addDays(28)->timestamp])) {

                return response()->json(['error' => 'invalid_credentials'], 401);

            }
        } catch (JWTException $e) {

            return response()->json(['error' => 'could_not_create_token'], 500);

        }
        return response()->json(['user' => $user, 'token' => $token, 'status' => 200], 200);
    }

    public function loginWithPhonePasswordDrivers(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mobile' => 'required',
            'country_code' => 'required',
            'password' => 'required'
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
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];

        $user = Drivers::where($matchThese)->first();

        if (!$user)
            return response()->json(['error' => 'User not found.'], 500);

        // Account Validation
        if (!(new BcryptHasher)->check($request->input('password'), $user->password)) {

            return response()->json(['error' => 'Phone Number or password is incorrect. Authentication failed.'], 401);
        }

        // Login Attempt
        $credentials = $request->only('country_code', 'mobile', 'password');

        try {

            JWTAuth::factory()->setTTL(40320); // Expired Time 28days

            if (!$token = JWTAuth::fromUser($user, ['exp' => Carbon::now()->addDays(28)->timestamp])) {

                return response()->json(['error' => 'invalid_credentials'], 401);

            }
        } catch (JWTException $e) {

            return response()->json(['error' => 'could_not_create_token'], 500);

        }
        return response()->json(['user' => $user, 'token' => $token, 'status' => 200], 200);
    }

    public function firebaseauth(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mobile' => 'required',
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
        $url = url('/api/v1/success_verified');
        return view('fireauth', ['mobile' => $request->mobile, 'redirect' => $url]);
    }

    public function success_verified()
    {
        return view('verified');
    }

    public function verifyPhoneForFirebaseRegistrations(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'country_code' => 'required',
            'mobile' => 'required'
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

        $data = User::where('email', $request->email)->first();
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];
        $data2 = User::where($matchThese)->first();
        if (is_null($data) && is_null($data2)) {
            $response = [
                'data' => true,
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);
        }

        $response = [
            'data' => false,
            'message' => 'email or mobile is already registered',
            'status' => 500
        ];
        return response()->json($response, 200);
    }

    public function verifyEmailForReset(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required',
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
        $matchThese = ['email' => $request->email];

        $user = User::where($matchThese)->first();

        if (!$user)
            return response()->json(['data' => false, 'error' => 'User not found.'], 500);

        $settings = Settings::take(1)->first();
        $generalInfo = General::take(1)->first();
        $mail = $request->email;
        $username = $request->email;
        $subject = 'Reset Password';
        $otp = random_int(100000, 999999);
        $savedOTP = Otp::create([
            'otp' => $otp,
            'email' => $request->email,
            'status' => 0,
        ]);
        $mailTo = Mail::send(
            'mails/reset',
            [
                'app_name' => $generalInfo->name,
                'otp' => $otp
            ]
            ,
            function ($message) use ($mail, $username, $subject, $generalInfo) {
                $message->to($mail, $username)
                    ->subject($subject);
                $message->from($generalInfo->email, $generalInfo->name);
            }
        );

        $response = [
            'data' => true,
            'mail' => $mailTo,
            'otp_id' => $savedOTP->id,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);

    }

    public function verifyEmailForResetDriver(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required',
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
        $matchThese = ['email' => $request->email];

        $user = Drivers::where($matchThese)->first();

        if (!$user)
            return response()->json(['data' => false, 'error' => 'User not found.'], 500);

        $settings = Settings::take(1)->first();
        $generalInfo = General::take(1)->first();
        $mail = $request->email;
        $username = $request->email;
        $subject = 'Reset Password';
        $otp = random_int(100000, 999999);
        $savedOTP = Otp::create([
            'otp' => $otp,
            'email' => $request->email,
            'status' => 0,
        ]);
        $mailTo = Mail::send(
            'mails/reset',
            [
                'app_name' => $generalInfo->name,
                'otp' => $otp
            ]
            ,
            function ($message) use ($mail, $username, $subject, $generalInfo) {
                $message->to($mail, $username)
                    ->subject($subject);
                $message->from($generalInfo->email, $generalInfo->name);
            }
        );

        $response = [
            'data' => true,
            'mail' => $mailTo,
            'otp_id' => $savedOTP->id,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);

    }

    public function verifyPhoneForFirebase(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mobile' => 'required',
            'country_code' => 'required',
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
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];

        $user = User::where($matchThese)->first();

        if (!$user)
            return response()->json(['data' => false, 'error' => 'User not found.'], 500);
        $response = [
            'data' => true,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function verifyPhoneForFirebaseNew(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mobile' => 'required',
            'country_code' => 'required',
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
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];

        $user = User::where($matchThese)->first();

        if (!$user) {
            $response = [
                'data' => true,
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);
        }
        return response()->json(['data' => false, 'error' => 'Phone exist'], 500);

    }

    public function verifyPhoneForFirebaseDriver(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mobile' => 'required',
            'country_code' => 'required',
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
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];

        $user = Drivers::where($matchThese)->first();

        if (!$user)
            return response()->json(['data' => false, 'error' => 'User not found.'], 500);
        $response = [
            'data' => true,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function verifyPhoneForFirebaseDriverNew(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mobile' => 'required',
            'country_code' => 'required',
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
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];

        $user = Drivers::where($matchThese)->first();

        if (!$user) {
            $response = [
                'data' => true,
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);
        }
        return response()->json(['data' => false, 'error' => 'Phone exist'], 500);
    }

    public function loginWithMobileOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mobile' => 'required',
            'country_code' => 'required',
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
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];

        $user = User::where($matchThese)->first();

        if (!$user)
            return response()->json(['error' => 'User not found.'], 500);

        try {

            JWTAuth::factory()->setTTL(40320); // Expired Time 28days

            if (!$token = JWTAuth::fromUser($user, ['exp' => Carbon::now()->addDays(28)->timestamp])) {

                return response()->json(['error' => 'invalid_credentials'], 401);

            }
        } catch (JWTException $e) {

            return response()->json(['error' => 'could_not_create_token'], 500);

        }
        return response()->json(['user' => $user, 'token' => $token, 'status' => 200], 200);
    }

    public function loginWithMobileOtpDriver(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mobile' => 'required',
            'country_code' => 'required',
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
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];

        $user = Drivers::where($matchThese)->first();

        if (!$user)
            return response()->json(['error' => 'User not found.'], 500);

        try {

            JWTAuth::factory()->setTTL(40320); // Expired Time 28days

            if (!$token = JWTAuth::fromUser($user, ['exp' => Carbon::now()->addDays(28)->timestamp])) {

                return response()->json(['error' => 'invalid_credentials'], 401);

            }
        } catch (JWTException $e) {

            return response()->json(['error' => 'could_not_create_token'], 500);

        }
        return response()->json(['user' => $user, 'token' => $token, 'status' => 200], 200);
    }

    public function deleteUserAccount(Request $request)
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
        $data = User::find($request->id);
        if ($data) {
            $data->delete();
            DB::table('address')->where('uid', $request->id)->delete();
            DB::table('chat_message')->where('uid', $request->id)->delete();
            DB::table('chat_message')->where('from_id', $request->id)->delete();
            DB::table('chat_room')->where('uid', $request->id)->delete();
            DB::table('chat_room')->where('participants', $request->id)->delete();
            DB::table('complaints')->where('uid', $request->id)->delete();
            DB::table('favourite')->where('uid', $request->id)->delete();
            DB::table('orders')->where('uid', $request->id)->delete();
            DB::table('referralcodes')->where('uid', $request->id)->delete();
            DB::table('rating')->where('uid', $request->id)->delete();
            $response = [
                'data' => $data,
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);
        }
    }

    public function deleteStoreAccount(Request $request)
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
        $data = User::find($request->id);
        if ($data) {
            $data->delete();
            DB::table('store')->where('uid', $request->id)->delete();
            DB::table('rating')->where('sid', $request->id)->delete();
            DB::table('products')->where('store_id', $request->id)->delete();
            DB::table('orders')->whereIn('store_id', $request->id)->delete();
            DB::table('favourite')->whereIn('ids', $request->id)->delete();
            DB::table('complaints')->whereIn('store_id', $request->id)->delete();
            DB::table('chat_message')->where('uid', $request->id)->delete();
            DB::table('chat_message')->where('from_id', $request->id)->delete();
            DB::table('chat_room')->where('uid', $request->id)->delete();
            DB::table('chat_room')->where('participants', $request->id)->delete();
            $response = [
                'data' => $data,
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);
        }
    }

    public function deleteDriverAccount(Request $request)
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
        $data = Drivers::find($request->id);
        if ($data) {
            $data->delete();
            DB::table('orders')->where('driver_id', $request->id)->delete();
            DB::table('rating')->where('did', $request->id)->delete();
            DB::table('complaints')->whereIn('driver_id', $request->id)->delete();
            $response = [
                'data' => $data,
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);
        }
    }
}
