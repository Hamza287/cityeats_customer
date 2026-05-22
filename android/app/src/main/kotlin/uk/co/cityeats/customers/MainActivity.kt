package uk.co.cityeats.customers

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Enable edge-to-edge for Android 15+ (SDK 35) compatibility
        // FlutterActivity doesn't extend ComponentActivity, so we use WindowCompat
        // This is the correct approach for Flutter apps as per Google Play Console requirements
        WindowCompat.setDecorFitsSystemWindows(window, false)
        
        super.onCreate(savedInstanceState)
    }
}

