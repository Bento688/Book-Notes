import passport from "passport";

export const userLogin = (req, res) => {
  res.render("login.ejs");
};

export const googleLogin = passport.authenticate("google", {
  scope: ["profile", "email"],
});

export const googleCallBack = passport.authenticate("google", {
  successRedirect: "/",
  failureRedirect: "/",
});

export const userLogout = (req, res) => {
  req.logout(function (err) {
    if (err) {
      return next(err);
    }
    res.redirect("/");
  });
};
