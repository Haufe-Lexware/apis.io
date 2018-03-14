if (Meteor.isClient) {
  Meteor.startup(function () {
    if (!Meteor.settings.private.recaptcha) {
      return;
    }

    reCAPTCHA.config({
      theme: 'light',  // 'light' default or 'dark'
      publickey: Meteor.settings.public.recaptcha.publickey
    });
  });
}
