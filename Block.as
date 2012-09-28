﻿package {		import com.greensock.TweenLite;		import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.MouseEvent;	import flash.filters.BitmapFilterQuality;	import flash.filters.DropShadowFilter;	import flash.geom.Point;
		public class Block extends MovieClip {				/**		 * Used to drag the block		 */		public var header:MovieClip;				/**		 * Used to change the size of the block		 */		public var dragger:MovieClip;				public var background:MovieClip;		public var border:MovieClip;				private var container:Grid;		private var containerW:Number;		private var containerH:Number;				private var offsetX:Number;		private var offsetY:Number;				private var currentX:Number;		private var currentY:Number;				private var currentW:Number;		private var currentH:Number;				private var minW:Number = 50;		private var minH:Number = 50;				private var status:Number;				/**		 * Constructor		 */		public function Block( container:Grid ) {			this.container = container;						// Save the container width and height			containerW = container.width;			containerH = container.height;						// Enable header and dragger button mode			header.buttonMode = true;			dragger.buttonMode = true;						// Listen to header mouse down event			header.addEventListener( MouseEvent.MOUSE_DOWN, onHeaderMouseDownHandler );						// Listen to dragger mouse down event			dragger.addEventListener( MouseEvent.MOUSE_DOWN, onDraggerMouseDownHandler );						// Listen to background mouse down event			background.addEventListener( MouseEvent.MOUSE_DOWN, onBackgroundMouseDownHandler );		}				/**		 * 		 */		private function onHeaderMouseDownHandler( e:MouseEvent ):void {			// Set status to drag & drop			status = 0;						// Record the mouse position			offsetX = this.mouseX;			offsetY = this.mouseY;						// Save the current position for later use			currentX = this.x;			currentY = this.y;						putOnTop();			dropShadow();						// Then listen to stage events			listenToStageEvents();						container.lightOn( getCellsIndices() );		}				/**		 * 		 */		private function onDraggerMouseDownHandler( e:MouseEvent ): void {			// Set status to resize			status = 1;						// Record the mouse position			offsetX = stage.mouseX;			offsetY = stage.mouseY;						// Record the current width and height			currentW = background.width;			currentH = background.height;						putOnTop();			dropShadow();						listenToStageEvents();			container.lightOn( getCellsIndices( true ) );		}				/**		 * 		 */		private function onBackgroundMouseDownHandler( e:MouseEvent ): void {			putOnTop();		}				/**		 * 		 */		private function listenToStageEvents(): void {			stage.addEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMoveHandler );			stage.addEventListener( MouseEvent.MOUSE_UP, onStageMouseUpHandler );		}				/**		 * 		 */		private function onStageMouseMoveHandler( e:MouseEvent ): void {			switch ( status ) {				// Drag & Drop				case 0:					var px:Number = container.mouseX - offsetX;					var py:Number = container.mouseY - offsetY;										move( px, py );										container.lightOn( getCellsIndices() );										break;								// Resize				case 1:					var w:Number = currentW + stage.mouseX - offsetX;					var h:Number = currentH + stage.mouseY - offsetY;										resize( w, h );										container.lightOn( getCellsIndices( true ) );										break;			}						e.updateAfterEvent();		}				/**		 * 		 */		private function onStageMouseUpHandler( e:MouseEvent ): void {			// Remove stage event listeners			stage.removeEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMoveHandler );			stage.removeEventListener( MouseEvent.MOUSE_UP, onStageMouseUpHandler );						// Drop it			switch ( status ) {				case 0:					dropIt();					break;				case 1:					sizeIt();					break;			} 						// Reset the status			status = -1;						removeShadow();						container.lightOff();		}				/**		 * 		 */		private function putOnTop(): void {			container.setChildIndex( this, container.numChildren - 1 );		}				/**		 * Drop shadow on background		 */		private function dropShadow(): void {			this.alpha = 0.8;			background.filters = [ new DropShadowFilter(5, 45, 0x999999, BitmapFilterQuality.HIGH, 5, 5, 1) ];		}				/**		 * Remove the shadow filter		 */		private function removeShadow(): void {			this.alpha = 1;			background.filters = [];		}				/**		 * 		 */		private function restrictPosition( px:Number, py:Number ):Object {			px = px < 0 ? 0 : px;			py = py < 0 ? 0 : py;			px = (px + background.width) > containerW ? (containerW - background.width) : px;			py = (py + background.height) > containerH ? (containerH - background.height) : py;						return { x:px, y:py };		}				/**		 * 		 */		private function restrictSize( pw:Number, ph:Number ):Object {			pw = ( this.x + pw ) > containerW ? ( containerW - this.x ) : pw;			ph = ( this.y + ph ) > containerH ? ( containerH - this.y ) : ph;						pw = pw < minW ? minW : pw;			ph = ph < minH ? minH : ph;						return { w:pw, h:ph };		}				/**		 * 		 */		private function dropIt(): void {			// Get hightlighted cells info			var info:Object = container.getCellsInfo( getCellsIndices() );			move( info.x, info.y, true );		}				/**		 * 		 */		private function sizeIt(): void {			// Get hightlighted cells info			var info:Object = container.getCellsInfo( getCellsIndices( true ) );			resize( info.w, info.h, true );		}				/**		 * Move the block		 */		private function move( px:Number, py:Number, animate:Boolean = false ): void {			var p:Object = restrictPosition(px, py);						if ( animate ) {				TweenLite.to( this, 0.1, { x:p.x, y:p.y } );			} else {				this.x = p.x;				this.y = p.y;			}		}				/**		 * Resize the block		 */		private function resize( w:Number, h:Number, animate:Boolean = false ): void {			var s:Object = restrictSize( w, h );						var time:Number = animate ? 0.1 : 0;			TweenLite.to( background, time, { width:s.w, height:s.h } );			TweenLite.to( header, time, { width:s.w } );			TweenLite.to( border, time, { width:s.w, height:s.h } );			TweenLite.to( dragger, time, { x:s.w - dragger.width, y:s.h - dragger.height } );					}				private function getCellsIndices( extend:Boolean = false ): Array {			return container.getCellsIndices( this.x, this.y, background.width, background.height, extend );		}	}	}