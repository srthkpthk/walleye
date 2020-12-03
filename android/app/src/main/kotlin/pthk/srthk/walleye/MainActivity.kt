package pthk.srthk.walleye

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "android_app_retain").apply {
            setMethodCallHandler { method, rslt ->
                if (method.method == "sendToHome") {
                    moveTaskToBack(true)
                }
            }
        }
    }
}
