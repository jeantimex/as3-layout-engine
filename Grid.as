package {
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	
	public class Grid extends MovieClip {
		
		public var background:MovieClip;
		private var g:Graphics;
		
		public static var gridW:Number = 300;
		public static var gridH:Number = 160;
		
		public static var sizeW:Number = 3;
		public static var sizeH:Number = 3;
		
		/**
		 * Constructor
		 */
		public function Grid() {
			g = background.graphics;
		}
		
		/**
		 * 
		 */
		public function lightOn( cells:Array ): void {
			// Clear the current highlights
			g.clear();
			g.beginFill( 0x66CCFF, 0.2 );
			
			for (var i:int = 0; i < cells.length; ++i) {
				var index:Number = cells[i];
				
				var px:Number = int( index % sizeW ) * Grid.gridW;
				var py:Number = int( index / sizeW ) * Grid.gridH;
				
				g.drawRect( px, py, gridW, gridH );
			}
			
			g.endFill();
		}
		
		/**
		 * 
		 */
		public function lightOff(): void {
			g.clear();
		}
		
		/**
		 * 
		 */
		public function getCellsIndices( px:Number, py:Number, pw:Number, ph:Number, extend:Boolean = false ):Array {
			var cells:Array = new Array();
			
			var ox:Number = Math.round( px / gridW );
			var oy:Number = Math.round( py / gridH );
			
			var ex:Number = ( px + pw ) / gridW;
			var ey:Number = ( py + ph ) / gridH;
			
			if ( extend ) {
				ex = Math.ceil( ex );
				ey = Math.ceil( ey );
			} else {
				ex = Math.round( ex );
				ey = Math.round( ey );
			}
			
			// Restrict the index
			ox = ox > sizeW ? sizeW : ox;
			oy = oy > sizeH ? sizeH : oy;
			
			ex = ex > sizeW ? sizeW : ex;
			ey = ey > sizeH ? sizeH : ey;
			
			for (var i:int = ox; i < ex; ++i) {
				for (var j:int = oy; j < ey; ++j) {
					cells.push(i + j * sizeW);
				}
			}
			
			return cells;
		}
		
		/**
		 * 
		 */
		public function getCellsInfo( cells:Array ):Object {
			cells.sort();
			
			// Left vertex index
			var firstIdx:Number = cells[0];
			
			var px:Number = int( firstIdx % sizeW ) * gridW;
			var py:Number = int( firstIdx / sizeW ) * gridH;
			
			// Lower right vertex index
			var lastIdx:Number = cells[cells.length - 1];
			var w:Number = ( int( lastIdx % sizeW ) - int( firstIdx % sizeW ) + 1 ) * gridW;
			var h:Number = ( int( lastIdx / sizeW ) - int( firstIdx / sizeW ) + 1 ) * gridH;
			
			return { x:px, y:py, w:w, h:h };
		}
	}
}