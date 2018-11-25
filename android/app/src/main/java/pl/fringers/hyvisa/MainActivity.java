package pl.fringers.hyvisa;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import android.bluetooth.BluetoothAdapter;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.InvocationTargetException;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "samples.flutter.io/getBluetoothMacAddress";

  @Override
  public void onCreate(Bundle savedInstanceState) {

    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall call, Result result) {
        // TODO
        if (call.method.equals("getBluetoothMacAddress")) {
          result.success(getBluetoothMacAddress());
        }
      }
    });
  }

  private String getBluetoothMacAddress() {
    BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
    String bluetoothMacAddress = "";
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
      try {
        Field mServiceField = bluetoothAdapter.getClass().getDeclaredField("mService");
        mServiceField.setAccessible(true);

        Object btManagerService = mServiceField.get(bluetoothAdapter);

        if (btManagerService != null) {
          bluetoothMacAddress = (String) btManagerService.getClass().getMethod("getAddress").invoke(btManagerService);
        }
      } catch (NoSuchFieldException e) {

      } catch (NoSuchMethodException e) {

      } catch (IllegalAccessException e) {

      } catch (InvocationTargetException e) {

      }
    } else {
      bluetoothMacAddress = bluetoothAdapter.getAddress();
    }
    return bluetoothMacAddress;
  }
}
