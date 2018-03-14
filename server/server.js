if (Meteor.isServer) {
  Meteor.startup(function () {
    if (!Meteor.settings.private.recaptcha) {
      return;
    }

    // code to run on server at startup
    reCAPTCHA.config({
        privatekey: Meteor.settings.private.recaptcha.privateKey
    });
  });
}
