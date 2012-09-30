package {
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class Grid extends MovieClip {
		
		private var background:Sprite;
		private var frame:Sprite;
		
		private var g:Graphics;
		
		private var gridW:Number = 0;
		private var gridH:Number = 0;
		
		private var sizeW:Number = 1;
		private var sizeH:Number = 1;
		
		private var blocks:Array;
		
		/**
		 * Constructor
		 */
		public function Grid() {
			blocks = new Array();
			
			background = new Sprite();
			frame = new Sprite();
			
			g = background.graphics;
			
			addChild( background );
			addChild( frame );
		}
		
		/**
		 * 
		 */
		public function init( option:Object ): void {
			// Configure the grid
			x = option.hasOwnProperty( "x" ) ? option.x : 0;
			y = option.hasOwnProperty( "y" ) ? option.y : 0;
			sizeW = option.hasOwnProperty( "sizeW" ) ? option.sizeW : 1;
			sizeH = option.hasOwnProperty( "sizeH" ) ? option.sizeH : 1;
			gridW = option.hasOwnProperty( "gridW" ) ? option.gridW : 0;
			gridH = option.hasOwnProperty( "gridH" ) ? option.gridH : 0;
			
			// Draw grid frame
			while ( frame.numChildren > 0 ) frame.removeChildAt( frame.numChildren - 1 );
			
			var dlTop:DashedLine = new DashedLine( sizeW*gridW, 0x999999, 5, 2, 0.1 );
			dlTop.drawBetween( new Point( 0, 0 ), new Point( sizeW * gridW, 0 ) );
			
			var dlRight:DashedLine = new DashedLine( sizeH*gridH, 0x999999, 5, 2, 0.1 );
			dlRight.drawBetween( new Point( sizeW * gridW, 0 ), new Point( sizeW * gridW, sizeH * gridH ) );
			
			var dlBottom:DashedLine = new DashedLine( sizeW*gridW, 0x999999, 5, 2, 0.1 );
			dlBottom.drawBetween( new Point( 0, sizeH * gridH ), new Point( sizeW * gridW, sizeH * gridH ) );
			
			var dlLeft:DashedLine = new DashedLine( sizeH*gridH, 0x999999, 5, 2, 0.1 );
			dlLeft.drawBetween( new Point( 0, 0 ), new Point( 0, sizeH * gridH ) );
			
			frame.addChild( dlTop );
			frame.addChild( dlRight );
			frame.addChild( dlBottom );
			frame.addChild( dlLeft );
			
			// Draw middle dashlines
			var i, j:int;
			var dl:DashedLine;
			
			for ( i = 1; i < sizeH; ++i ) {
				dl = new DashedLine( sizeW*gridW, 0x999999, 5, 2, 0.1 );
				dl.drawBetween( new Point( 0, i * gridH ), new Point( sizeW * gridW, i * gridH ) );
				frame.addChild( dl );
			}
			
			for ( i = 1; i < sizeW; ++i ) {
				dl = new DashedLine( sizeH*gridH, 0x999999, 5, 2, 0.1 );
				dl.drawBetween( new Point( i * gridW, 0 ), new Point( i * gridW, sizeH * gridH ) );
				frame.addChild( dl );
			}
			
			// Add frame label
			for ( i = 0; i < sizeH; ++i ) {
				for ( j = 0; j < sizeW; ++j ) {
					var lbl:TextField = new TextField();
					lbl.width = gridW;
					lbl.height = gridH;
					lbl.text = String( Number( i * sizeW + j ) );
					lbl.x = j * gridW;
					lbl.y = i * gridH;
					lbl.alpha = 0.8;
					frame.addChild( lbl );
				}
			}
		}
		
		/**
		 * 
		 */
		public function addBlock( block:Block ):Boolean {
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
			g.beginFill( 0xFF9900, 0.5 );
			
			for (var i:int = 0; i < cells.length; ++i) {
				var index:Number = cells[i];
				
				var px:Number = int( index % sizeW ) * gridW;
				var py:Number = int( index / sizeW ) * gridH;
				
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
			var pw:Number = block.w;
			var ph:Number = block.h;
			
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
			
			cells.sort( Array.NUMERIC );
			//trace("---------------");
			//trace("cells: " + cells);
			
			// Get cell min and max row index and column index
			var minRow:int = int( cells[0] / sizeW );
			var minCol:int = int( cells[0] % sizeW );
			var maxRow:int = int( cells[cells.length - 1] / sizeW );
			var maxCol:int = int( cells[cells.length - 1] % sizeW );
			/*
			trace("min row: " + minRow);
			trace("min col: " + minCol);
			trace("max row: " + maxRow);
			trace("max col: " + maxCol);
			*/
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
							//trace( "k: " + k );
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
							
							var areaRight:Number = ( block.x + block.w ) < kCellRight ? mouseX : kCellRight;
							var areaBottom:Number = ( block.y + block.h ) < kCellBottom ? mouseY : kCellBottom;
							
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
				
				if ( areas.length > 0 ) {
					return areas[0].cells;
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
			cells.sort( Array.NUMERIC );
			
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