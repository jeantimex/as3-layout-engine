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
		
		public var blocks:Array;
		
		/**
		 * Constructor
		 */
		public function Grid() {
			blocks = new Array();
			g = background.graphics;
		}
		
		/**
		 * 
		 */
		public function addBlock( block:Block ):Boolean {
			block.container = this;
			blocks.push( block );
			addChild( block );
			return true;
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
		public function getCellsIndices( block:Block, isDragging:Boolean = false ):Array {
			var i, j, k, m, n:int;
			
			var cells:Array = new Array();
			
			var px:Number = block.x;
			var py:Number = block.y;
			var pw:Number = block.background.width;
			var ph:Number = block.background.height;
			
			var ox:Number = Math.round( px / gridW );
			var oy:Number = Math.round( py / gridH );
			
			var ex:Number = ( px + pw ) / gridW;
			var ey:Number = ( py + ph ) / gridH;
			
			if ( isDragging ) {
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
			
			for ( i = ox; i < ex; ++i ) {
				for ( j = oy; j < ey; ++j ) {
					cells.push( i + j * sizeW );
				}
			}
			
			cells.sort();
			
			// TODO...
			if ( isDragging ) {
				
				for ( i = 0; i < blocks.length; ++i ) {
					if ( blocks[i] as Block == block ) {
						continue;
					}
					var conflicts:Array = getConflicts( cells, blocks[i] as Block );
					for ( j = 0; j < conflicts.length; ++j ) {
						// Same column as block.cells[0]
						if ( ( conflicts[j] - block.cells[0] ) % sizeW == 0 ) {
							// Remove down from the conflict cell
							for ( k = conflicts[j]; k < sizeW * sizeH; k += sizeW ) {
								Utils.arraySplice( cells, k );
							}
						} else {
							// Remove whole column of conflict cell and all columns from right
							for ( m = int( conflicts[j] % sizeW ); m <= int( cells[cells.length - 1] % sizeW ); ++m ) {
								for ( n = m; n < sizeW * sizeH; n += sizeW ) {
									Utils.arraySplice( cells, n );
								}
							}
						}
					}
				}
				
			}
			
			return cells;
		}
		
		/**
		 * 
		 */
		private function getConflicts( cells:Array, block:Block ):Array {
			var conflicts:Array = new Array();
			for ( var i:int = 0; i < cells.length; ++i ) {
				if ( block.cells.indexOf( cells[i] ) > -1 ) {
					conflicts.push( cells[i] );
				}
			}
			return conflicts;
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