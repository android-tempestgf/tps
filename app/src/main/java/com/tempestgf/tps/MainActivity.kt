// File: app/src/main/java/com/tempestgf/tps/MainActivity.kt
package com.tempestgf.tps

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.tempestgf.tps.ui.theme.TravelPlannerScaffoldingTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            TravelPlannerScaffoldingTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    HomeScreen(modifier = Modifier.padding(innerPadding))
                }
            }
        }
    }
}

@Composable
fun HomeScreen(modifier: Modifier = Modifier) {
    val context = LocalContext.current
    Column(modifier = modifier) {
        Text(text = "Bienvenido a TripWise!")
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = {
            // TODO: Navegar a la pantalla de Trips (a implementar)
        }) {
            Text(text = "Trips")
        }
        Spacer(modifier = Modifier.height(8.dp))
        Button(onClick = {
            // TODO: Navegar a la pantalla de Itinerary (a implementar)
        }) {
            Text(text = "Itinerary")
        }
        Spacer(modifier = Modifier.height(8.dp))
        Button(onClick = {
            context.startActivity(Intent(context, AboutActivity::class.java))
        }) {
            Text(text = "About")
        }
        Spacer(modifier = Modifier.height(8.dp))
        Button(onClick = {
            context.startActivity(Intent(context, TermsActivity::class.java))
        }) {
            Text(text = "Terms & Conditions")
        }
    }
}

@Preview(showBackground = true)
@Composable
fun HomeScreenPreview() {
    TravelPlannerScaffoldingTheme {
        HomeScreen()
    }
}
