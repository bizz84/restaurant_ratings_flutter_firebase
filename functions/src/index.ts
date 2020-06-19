import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

admin.initializeApp()

export const updateRestaurantRating = functions.firestore
    .document(`restaurants/{restaurantId}/ratings/{uid}`)
    .onWrite(async (change, _) => await updateRating(change))

async function updateRating(change: functions.Change<functions.firestore.DocumentSnapshot>) {

    const restaurantRatingsRef = change.after.ref.parent
    let numRatings = 0
    let total = 0
    const docRefs = await restaurantRatingsRef.listDocuments()
    for (const docRef of docRefs) {
        const snapshot = await docRef.get()
        const data = snapshot.data()
        if (data !== undefined) {
            total += data.rating
            numRatings++
        }
    }
    const avgRating = total / numRatings

    const restaurantRef = restaurantRatingsRef.parent!
    console.log(`${restaurantRef.path} now has ${numRatings} ratings with a ${avgRating} average`)
    await restaurantRef.update({
        avgRating: avgRating,
        numRatings: numRatings
    })
}
