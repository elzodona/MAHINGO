<?php

namespace App\Http\Controllers;

use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use App\Http\Requests\UserRequest;
use Illuminate\Database\QueryException;
use App\Http\Resources\Resources\UserResource;
use App\Http\Controllers\Messages\MessageController;
use App\Http\Resources\Collections\UserCollection;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class UserController extends Controller
{

    private $message;

    public function __construct(){
        $this->message = new MessageController;
    }

    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $users = User::all();
        return new UserCollection($users);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(UserRequest $request)
    {
        try {

            $validatedData = $request->validated();
            User::create($validatedData);
            return $this->message->succedRequest('User '.$this->message->handleException[0]);

        } catch (QueryException $e){

            return $this->message->errorRequest($this->message->handleException[5]);

        } catch (Exception $e) {

            return $this->message->errorRequest($this->message->handleException[6]);

        }
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        try {

            $user = User::findOrFail($id);
            $userData = new UserResource($user);
            return $this->message->succedRequestWithData($user);

            } catch (ModelNotFoundException $e) {

                return $this->message->failedRequest('User ID'.$this->message->handleException[4]);

            } catch (QueryException $e) {


                return $this->message->errorRequest($this->message->handleException[5]);


            } catch (Exception $e) {

                return $this->message->errorRequest($this->message->handleException[6]);

            }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UserRequest $request,$id)
    {
        try {

            $validatedData =  $request->only(array_keys($request->rules()));
            $user = User::findOrFail($id);
            $user->update($validatedData);

            return $this->message->succedRequest('User '.$this->message->handleException[1]);

        } catch (ModelNotFoundException $e) {

                return $this->message->failedRequest('User ID'.$this->message->handleException[4]);

            } catch (QueryException $e) {


                return $this->message->errorRequest($this->message->handleException[5]);


            } catch (Exception $e) {

                return $this->message->errorRequest($this->message->handleException[6]);

            }

    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try {

            $user = User::findOrFail($id);
            $user->delete();
            return $this->message->succedRequest('User'. $this->message->handleException[2]);

        } catch (ModelNotFoundException $e) {

            return $this->message->failedRequest('User ID'.$this->message->handleException[4]);

        } catch (QueryException $e) {


            return $this->message->errorRequest($this->message->handleException[5]);


        } catch (Exception $e) {

            return $this->message->errorRequest($this->message->handleException[6]);

        }
    }

    /**
     * Restrore the specified resource from storage.
     */
    public function restore($id){
        try {

            $user = User::onlyTrashed()->findOrFail($id);
            $user->restore();
            return $this->message->succedRequest('User'.$this->message->handleException[3]);

        } catch (ModelNotFoundException $e){

            return $this->message->failedRequest('User ID'.$this->message->handleException[4]);

        }catch (QueryException $e) {

            return $this->message->errorRequest($this->message->handleException[5]);


        } catch (Exception $e) {

            return $this->message->errorRequest($this->message->handleException[6]);

        }

    }
}
