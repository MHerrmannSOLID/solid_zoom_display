# solid_zoom_display

A flexible zoom display.

## When and why 
For most standard Flutter applications, the [InteractiveViewer](https://api.flutter.dev/flutter/widgets/InteractiveViewer-class.html) widget is a convenient and sufficient choice for handling basic pan-and-zoom functionality. 

However, **SolidZoomDisplay** is built for scenarios that demand high-performance rendering and granular architectural control. It bridges the gap between simple UI zooming and complex, canvas-driven visualization.

### Why use SolidZoomDisplay?

While `InteractiveViewer` transforms existing widgets, **SolidZoomDisplay** is optimized for **Canvas-based drawing**. It offers several key advantages for specialized use cases:

* **Deep Rendering Control:** Gain total authority over the repainting process. With integrated **Level of Detail (LoD) scaling**, the system ensures the canvas only repaints when a visual threshold is met, saving precious CPU/GPU cycles.
* **Layered & Integrated Animations:** Manage complex motion with ease. The display supports **layered animation**, allowing you to isolate and repaint specific elements (like a sprite layer) without redrawing the entire scene.
* **Sophisticated Event Handling:** Move beyond basic coordinates. Our event system delivers precise image-space positions calculated against current zoom and pan states, providing contextually aware interaction.
* **Input Specialization:** Experience a clear architectural separation between **touch and mouse events**, ensuring your application feels native regardless of the hardware.