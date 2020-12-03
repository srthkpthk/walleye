package pthk.srthk.walleye

import android.content.Intent
import android.os.Handler
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val handler = Handler()
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "android_app_retain").apply {
            setMethodCallHandler { method, _ ->
                if (method.method == "sendToHome") {
                    val homeIntent = Intent(Intent.ACTION_MAIN, null)
                    homeIntent.addCategory(Intent.CATEGORY_HOME)
                    homeIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED)
                    startActivity(homeIntent)
                    Toast.makeText(applicationContext, "Wallpaper Set Succesfully", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }

}
