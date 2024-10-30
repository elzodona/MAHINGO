<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use App\Http\Requests\StoreNotificationRequest;
use App\Http\Requests\UpdateNotificationRequest;
use App\Http\Resources\Resources\NotificationResource;
use App\Models\Animal;
use Illuminate\Http\Request;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Exception;


class NotificationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
    }

    public function notifEventsByUser($id)
    {
        try {
            $events = Notification::where('user_id', $id)->get();
            return NotificationResource::collection($events);
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
            $event = Notification::create([
                'user_id' => $request->user_id,
                'animal_id' => $request->animal_id,
                'titre' => $request->titre,
                'description' => $request->description,
                'dateEvent' => $request->dateEvent,
                'heureDebut' => $request->heureDebut,
                'heureFin' => $request->heureFin,
                'etat' => 'non_lu'
            ]);

            return response()->json([
                'message' => 'Notification ajouté avec succès !',
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
            $event = Notification::findOrFail($id);

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
            $event = Notification::findOrFail($id);
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
