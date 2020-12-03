package pthk.srthk.walleye

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent


class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "android_app_retain").apply {
            setMethodCallHandler { method, rslt ->
                if (method.method == "sendToHome") {
                    android.util.Log.d("v", "configureFlutterEngine: called")
                    val homeIntent = Intent(Intent.ACTION_MAIN, null)
                    homeIntent.addCategory(Intent.CATEGORY_HOME)
                    homeIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED)
                    startActivity(homeIntent)
                }
            }
        }
    }
}
