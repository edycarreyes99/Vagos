import * as functions from 'firebase-functions';


// variables de control
let cantidadActividades;


// funcion que se manda a llamar al eliminar, actualizar o crear un nuevo documento
export const ActualizarCantidadActividades = functions.runWith({ timeoutSeconds: 300, memory: "2GB" }).firestore.document('Vagos/Control/Actividades/{Id}').onWrite((snapshot) => {
    functions.app.admin.firestore().collection('Vagos/Control/Actividades').onSnapshot((snap) => {
        cantidadActividades = snap.docs.length;
        functions.app.admin.firestore().doc('Vagos/Control').update({
            CantidadActividades: cantidadActividades
        }).then(res => {
            console.info('Se ha actualizado correctamente el valor de la cantidad de actividades en la funcion de onWrite');
        }).catch(e => {
            console.error(e);
        });
    });
});

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
