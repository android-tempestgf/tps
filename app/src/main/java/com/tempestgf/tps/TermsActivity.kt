// File: app/src/main/java/com/tempestgf/tps/TermsActivity.kt
package com.tempestgf.tps

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.tempestgf.tps.ui.theme.TravelPlannerScaffoldingTheme

class TermsActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            TravelPlannerScaffoldingTheme {
                Scaffold { innerPadding ->
                    TermsScreen(modifier = Modifier.padding(innerPadding))
                }
            }
        }
    }
}

@Composable
fun TermsScreen(modifier: Modifier = Modifier) {
    Column(modifier = modifier.verticalScroll(rememberScrollState())) {
        Text(text = "Términos y Condiciones", modifier = Modifier.padding(16.dp))
        Spacer(modifier = Modifier.height(8.dp))
        TODO@
        Text(
            text = "Aquí se mostrarán los términos y condiciones de uso de la aplicación. " +
                    "Este texto es de ejemplo y debe ser reemplazado por el contenido real.",
            modifier = Modifier.padding(16.dp)
        )
    }
}
