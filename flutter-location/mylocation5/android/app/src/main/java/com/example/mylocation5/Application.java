package com.example.mylocation5;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

import com.transistorsoft.flutter.backgroundgeolocation.FLTBackgroundGeolocationPlugin;
//import com.transistorsoft.flutter.backgroundfetch.BackgroundFetchPlugin;

public class Application  extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    @Override
    public void onCreate() {
        super.onCreate();
        FLTBackgroundGeolocationPlugin.setPluginRegistrant(this);
        //BackgroundFetchPlugin.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        GeneratedPluginRegistrant.registerWith(registry);
    }
}
