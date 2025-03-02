// File: app/src/main/java/com/tempestgf/tps/AboutActivity.kt
package com.tempestgf.tps

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.tempestgf.tps.ui.theme.TravelPlannerScaffoldingTheme

class AboutActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            TravelPlannerScaffoldingTheme {
                Scaffold { innerPadding ->
                    AboutScreen(modifier = Modifier.padding(innerPadding))
                }
            }
        }
    }
}

@Composable
fun AboutScreen(modifier: Modifier = Modifier) {
    Column(modifier = modifier) {
        Text(text = "TripWise")
        Spacer(modifier = Modifier.height(8.dp))
        Text(text = "Versión: 1.0")
        Spacer(modifier = Modifier.height(8.dp))
        Text(text = "Desarrollado por: Tempestgf")
        Spacer(modifier = Modifier.height(8.dp))
        Text(text = "TripWise es una aplicación para planificar y gestionar tus viajes.")
    }
}
