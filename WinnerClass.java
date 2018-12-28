public class WinnerClass {
	
	static int s1, s2, s3, s4, s5, s6, s7, s8, s9 = 0;
	
	public static void findWinner(boolean trueTick, int x) {
		if (trueTick && x == 1) {
			s1 = 1;
		}
		if (!trueTick && x == 1) {
			s1 = 2;
		}
		
		if (trueTick && x == 2) {
			s2 = 1;
		}
		if (!trueTick && x == 2) {
			s2 = 2;
		}
		
		if (trueTick && x == 3) {
			s3 = 1;
		}
		if (!trueTick && x == 3) {
			s3 = 2;
		}
		
		if (trueTick && x == 4) {
			s4 = 1;
		}
		if (!trueTick && x == 4) {
			s4 = 2;
		}
		
		if (trueTick && x == 5) {
			s5 = 1;
		}
		if (!trueTick && x == 5) {
			s5 = 2;
		}
		
		if (trueTick && x == 6) {
			s6 = 1;
		}
		if (!trueTick && x == 6) {
			s6 = 2;
		}
		
		if (trueTick && x == 7) {
			s7 = 1;
		}
		if (!trueTick && x == 7) {
			s7 = 2;
		}
		
		if (trueTick && x == 8) {
			s8 = 1;
		}
		if (!trueTick && x == 8) {
			s8 = 2;
		}
		
		if (trueTick && x == 9) {
			s9 = 1;
		}
		if (!trueTick && x == 9) {
			s9 = 2;
		}
		
		//Tick is a winner
		if (s1 == 1 && s2 == 1 && s3 == 1) {
			WindowConstructor.WinLine(0, 0, "h");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Tick");
		}
		if (s4 == 1 && s5 == 1 && s6 == 1) {
			WindowConstructor.WinLine(0, 150, "h");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Tick");
		}
		if (s7 == 1 && s8 == 1 && s9 == 1) {
			WindowConstructor.WinLine(0, 300, "h");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Tick");
		}
		if (s1 == 1 && s4 == 1 && s7 == 1) {
			WindowConstructor.WinLine(0, 0, "v");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Tick");
		}
		if (s2 == 1 && s5 == 1 && s8 == 1) {
			WindowConstructor.WinLine(150, 0, "v");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Tick");
		}
		if (s3 == 1 && s6 == 1 && s9 == 1) {
			WindowConstructor.WinLine(300, 0, "v");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Tick");
		}
		if (s1 == 1 && s5 == 1 && s9 == 1) {
			WindowConstructor.WinLine(0, 0, "dd");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Tick");
		}
		if (s3 == 1 && s5 == 1 && s7 == 1) {
			WindowConstructor.WinLine(0, 0, "du");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Tick");
		}
		
		//Toe is a winner
		if (s1 == 2 && s2 == 2 && s3 == 2) {
			WindowConstructor.WinLine(0, 0, "h");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Toe");
		}
		if (s4 == 2 && s5 == 2 && s6 == 2) {
			WindowConstructor.WinLine(0, 150, "h");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Toe");
		}
		if (s7 == 2 && s8 == 2 && s9 == 2) {
			WindowConstructor.WinLine(0, 300, "h");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Toe");
		}
		if (s1 == 2 && s4 == 2 && s7 == 2) {
			WindowConstructor.WinLine(0, 0, "v");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Toe");
		}
		if (s2 == 2 && s5 == 2 && s8 == 2) {
			WindowConstructor.WinLine(150, 0, "v");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Toe");
		}
		if (s3 == 2 && s6 == 2 && s9 == 2) {
			WindowConstructor.WinLine(300, 0, "v");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Toe");
		}
		if (s1 == 2 && s5 == 2 && s9 == 2) {
			WindowConstructor.WinLine(0, 0, "dd");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Toe");
		}
		if (s3 == 2 && s5 == 2 && s7 == 2) {
			WindowConstructor.WinLine(0, 0, "du");
			HandlerClass.listenerOn = false;
			WindowConstructor.ResetDialogue("Toe");
		}
	}

}
