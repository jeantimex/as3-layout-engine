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
			
			// Get cell min and max row index and column index
			var minRow:int = int( cells[0] / sizeW );
			var minCol:int = int( cells[0] % sizeW );
			var maxRow:int = int( cells[cells.length - 1] / sizeW );
			var maxCol:int = int( cells[cells.length - 1] % sizeW );
			
			//trace("min row: " + minRow);
			//trace("min col: " + minCol);
			//trace("max row: " + maxRow);
			//trace("max col: " + maxCol);
			
			// -------------------------------------------------------
			// 
			// During resizing, we need to find out the available cells
			//
			// -------------------------------------------------------
			if ( isDragging ) {
				
				for ( i = 0; i < blocks.length; ++i ) {
					if ( blocks[i] as Block == block ) {
						continue;
					}
					
					// Get all the confilct cells
					var conflicts:Array = getConflicts( cells, blocks[i] as Block );
					
					// Remove cells from conflict cell down to maxRow
					for ( j = 0; j < conflicts.length; ++j ) {
						for ( k = conflicts[j]; int( k / sizeW ) <= maxRow; k += sizeW ) {
							Utils.arraySplice( cells, k );
						}
					}
				}
				
				// Get all successive areas and their cells, do horizontal scan and row by row
				var areas:Array = new Array();
				
				for ( i = cells[0]; int( i / sizeW ) <= maxRow; i += sizeW ) {
					
					for ( j = 0; ; ++j ) {
						k = i + j;
						
						// If hits the "wall", calculate the areas from k up to minRow
						if ( cells.indexOf( k ) < 0 || int( k % sizeW ) == maxCol ) {
							
							// For each row we record the possible area and its cells
							// Later on we will find out the max area
							var obj:Object = {
								area: 0,
								cells: []
							};
							
							// Find the cells
							for ( m = int( cells[0] / sizeW ); m <= int( k / sizeW ); ++m ) {
								for ( n = int( cells[0] % sizeW ); n < int( k % sizeW ) + ( ( cells.indexOf( k ) < 0 ) ? 0 : 1 ); ++n ) {
									obj.cells.push( m * sizeW + n );
								}
							}
							
							// Calculate the area
							var kCellRight:Number = ( int( k % sizeW ) + ( ( cells.indexOf( k ) < 0 ) ? 0: 1 ) ) * gridW;
							var kCellBottom:Number = ( int( k / sizeW ) + 1 ) * gridH;
							
							var areaRight:Number = ( block.x + block.background.width ) < kCellRight ? mouseX : kCellRight;
							var areaBottom:Number = ( block.y + block.background.height ) < kCellBottom ? mouseY : kCellBottom;
							
							var areaWidth:Number = areaRight - int( cells[0] % sizeW ) * gridW;
							var areaHeight:Number = areaBottom - int( cells[0] / sizeW ) * gridH;
							
							//trace("[" + k + "]: " + kCellRight + ", " + kCellBottom);
							//trace("[m]: " + areaWidth + ", " + areaHeight);
							
							obj.area = areaWidth * areaHeight;
							
							//trace( "row " + int( i / sizeW ) + " [area: " + obj.area + ", cells: " + obj.cells + "]" );
							
							areas.push( obj );
							
							break;
						}
					}
				}
				
				areas.sortOn( [ "area" ], [ Array.NUMERIC | Array.DESCENDING ] );
				
				return areas[0].cells;
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