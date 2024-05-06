package com.example.novus_guard_solo

import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import android.animation.ObjectAnimator
//import androidx.appcompat.app.AppCompatActivity
import android.view.View

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        /*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            splashScreen.setOnExitAnimationListener { splashScreenView ->
                // Create your custom animation.
                val slideUp = ObjectAnimator.ofFloat(
                    splashScreenView,
                    View.TRANSLATION_Y,
                    0f,
                    -splashScreenView.height.toFloat()
                )
                slideUp.interpolator = AnticipateInterpolator()
                slideUp.duration = 200L

                // Call SplashScreenView.remove at the end of your custom animation.
                slideUp.doOnEnd { splashScreenView.remove() }

                // Run your animation.
                slideUp.start()
            }
        }*/
        }
    }
            /*override fun onCreate(savedInstanceState: Bundle?) {
                // Aligns the Flutter view vertically with the window.
                WindowCompat.setDecorFitsSystemWindows(getWindow(), false)

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    // Disable the Android splash screen fade out animation to avoid
                    // a flicker before the similar frame is drawn in Flutter.
                    splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
                }

                super.onCreate(savedInstanceState)
            }*/
