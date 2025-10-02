import dotenv from "dotenv";
dotenv.config();

import passport from "passport";
import { Strategy as GoogleStrategy } from "passport-google-oauth20";
import db from "./db.js";

// Passport configurations
export default function configurePassport() {
  passport.use(
    "google",
    new GoogleStrategy(
      {
        clientID: process.env.GOOGLE_CLIENT_ID,
        clientSecret: process.env.GOOGLE_CLIENT_SECRET,
        callbackURL: "http://localhost:3000/auth/google/callback",
        userProfileURL: "https://www.googleapis.com/oauth2/v3/userinfo",
      },
      async (accessToken, refreshToken, profile, cb) => {
        // console.log(profile);
        try {
          const newUserObject = {
            email:
              profile.emails && profile.emails.length > 0
                ? profile.emails[0].value
                : null,
            fname: profile.name ? profile.name.givenName : null,
            lname: profile.name ? profile.name.familyName : null,
            profilePicture:
              profile.photos && profile.photos.length > 0
                ? profile.photos[0].value
                : null,
          };
          // console.log(newUserObject);

          if (!newUserObject.email) {
            return cb(new Error("No email returned from Google"), null);
          }
          const result = await db.query(
            "SELECT * FROM users WHERE email = $1",
            [newUserObject.email]
          );
          if (result.rows.length == 0) {
            const newUser = await db.query(
              "INSERT INTO users (email, password, image_url, fname, lname) VALUES ($1, $2, $3, $4, $5) RETURNING *",
              [
                newUserObject.email,
                "google",
                newUserObject.profilePicture,
                newUserObject.fname,
                newUserObject.lname,
              ]
            );
            // console.log(newUser.rows[0]);
            cb(null, newUser.rows[0]);
          } else {
            //Already have existing user
            // console.log(result.rows[0]);
            cb(null, result.rows[0]);
          }
        } catch (err) {
          cb(err);
        }
      }
    )
  );

  passport.serializeUser((user, cb) => {
    return cb(null, user);
  });

  passport.deserializeUser((user, cb) => {
    return cb(null, user);
  });
}
