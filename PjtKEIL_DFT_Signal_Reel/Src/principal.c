

#include "DriverJeuLaser.h"

extern int DFT_ModuleAuCarre(short int * Signal64ech, char k);

extern short int LeSignal[64];

int result[64];

short int dma_buf[64];

void CallbackSystick(void)
{
		Start_DMA1(64);
		Wait_On_End_Of_DMA1();
		Stop_DMA1;
		for (char k=0; k<64; k++) {
			result[k] = DFT_ModuleAuCarre(dma_buf, k);
		}
}

int main(void)
{
// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Apr�s ex�cution : le coeur CPU est clock� � 72MHz ainsi que tous les timers
CLOCK_Configure();

// Timer systick
Systick_Period_ff(360000);
Systick_Prio_IT(1, CallbackSystick);
SysTick_On ;
SysTick_Enable_IT ;
	

// Configuration ADC
Init_TimingADC_ActiveADC_ff( ADC1, 72 );
Single_Channel_ADC( ADC1, 2 );
Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
Init_ADC1_DMA1(0, dma_buf);
	
//============================================================================	

// Test


while	(1)
	{
	}
}

