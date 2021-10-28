const unirest = require('unirest');
const fetch = require('node-fetch');
const firebase = require("firebase");
// Required for side-effects
require("firebase/firestore");

var firebaseConfig = {
    apiKey: "AIzaSyB79S_dvhzEFptukFvIMuoF8rR0PP1BDEE",
    authDomain: "chop-chop-25bce.firebaseapp.com",
    databaseURL: "https://chop-chop-25bce.firebaseio.com",
    projectId: "chop-chop-25bce",
    storageBucket: "chop-chop-25bce.appspot.com",
    messagingSenderId: "558826467576",
    appId: "1:558826467576:web:26ca683d4be1d40fd74b0d",
    measurementId: "G-E3Q47VLVBQ"
  };
  // Initialize Firebase
firebase.initializeApp(firebaseConfig);
var db = firebase.firestore();

const API_KEY = "7416dc48fba247819ce90cd88a3974ec";

const INGREDIENT_LIST = ['beans', 'salmon', 'lobster', 'eggs', 'garlic'];

let requestString = "https://api.spoonacular.com/recipes/findByIngredients?apiKey=7416dc48fba247819ce90cd88a3974ec&number=1000&ranking=1&ingredients=";

const ingredientsString = INGREDIENT_LIST.map(ingredient =>
   ingredient + '%2C'
);

recipes = [];
url = requestString + ingredientsString;
fetch(url, {
    method: "GET",
    withCredentials: true,
    headers: {
      "X-Auth-Token": "7416dc48fba247819ce90cd88a3974ec",
    }
  })
    .then(resp => resp.json())
    .then(function(data) {
        recipes = data;
      //console.log(data);
      console.log(recipes[2].usedIngredientCount + recipes[2].missedIngredientCount)
      console.log(recipes.length)
      for(var i = 0; i < recipes.length; i++) {
        db.collection("items").add({
            name: recipes[i].title,
            image: recipes[i].image,
            imageType: recipes[i].imageType,
            numberOfIngredients: recipes[i].usedIngredientCount + recipes[i].missedIngredientCount,
            missedIngredients: recipes[i].missedIngredients,
            usedIngredients: recipes[i].usedIngredients

        })
        .then(function(docRef) {
            console.log("Document written with ID: ", docRef.id);
        })
        .catch(function(error) {
            console.error("Error adding document: ", error);
        });
        
      }
      
    })
    .catch(function(error) {
      console.log(error);
    });
//console.log(recipes[0]);
//console.log(recipes[0][0].usedIngredients[0])

