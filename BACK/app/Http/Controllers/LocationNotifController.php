<?php

namespace App\Http\Controllers;

use App\Models\LocationNotif;
use App\Http\Requests\StoreLocationNotifRequest;
use App\Http\Requests\UpdateLocationNotifRequest;
use App\Http\Resources\Resources\LocationNotifResource;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Exception;


class LocationNotifController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
    }

    public function notifLocationByUser($id)
    {
        try {
            $location = LocationNotif::where('user_id', $id)->get();
            return LocationNotifResource::collection($location);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la récupération des notifications'], 500);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        try {
            $existingNotif = LocationNotif::where('user_id', $request->user_id)
                ->where('animal_id', $request->animal_id)
                ->where('dateSave', $request->dateSave)
                ->where('altitude', $request->altitude)
                ->where('longitude', $request->longitude)
                ->first();

            if ($existingNotif) {
                return response()->json([
                    'message' => 'Notification déjà existante !',
                ], 200);
            }

            $event = LocationNotif::create([
                'user_id' => $request->user_id,
                'animal_id' => $request->animal_id,
                'dateSave' => $request->dateSave,
                'altitude' => $request->altitude,
                'longitude' => $request->longitude,
                'heureNotif' => now()->format('H:i:s'),
                'etat' => 'non_lu'
            ]);

            return response()->json([
                'message' => 'Notification ajoutée avec succès !',
                'event' => $event,
            ], 201);
        } catch (Exception $e) {
            return response()->json([
                'error' => $e->getMessage(),
            ], 500);
        }
    }


    /**
     * Update the specified resource in storage.
     */
    public function update($id)
    {
        try {
            $event = LocationNotif::findOrFail($id);

            $event->update([
                'etat' => 'lu',
            ]);

            return response()->json([
                'message' => 'Notification lu avec succès !',
                'event' => $event
            ]);
        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Notification non trouvé'], 404);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la mise à jour de le notification : ' . $e->getMessage()], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try {
            $event = LocationNotif::findOrFail($id);
            $event->delete();

            return response()->json([
                'message' => 'Notification supprimé avec succès !'
            ]);
        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Notification non trouvé'], 404);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la suppression de la notification'], 500);
        }
    }

}
