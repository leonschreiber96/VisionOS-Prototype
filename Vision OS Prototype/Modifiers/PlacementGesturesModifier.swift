/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A modifier for placing objects.
*/

import SwiftUI
import RealityKit

extension View {
    /// Listens for gestures and places an item based on those inputs.
    func placementGestures(
        initialPosition: Point3D = .zero,
        axZoomIn: Bool = false,
        axZoomOut: Bool = false
    ) -> some View {
        self.modifier(
            PlacementGesturesModifier(
                initialPosition: initialPosition,
                axZoomIn: axZoomIn,
                axZoomOut: axZoomOut
            )
        )
    }
}

/// A modifier that adds gestures and positioning to a view.
private struct PlacementGesturesModifier: ViewModifier {
    var initialPosition: Point3D
    var axZoomIn: Bool
    var axZoomOut: Bool

    @State private var scale: Double = 1
    @State private var startScale: Double? = nil
    @State private var position: Point3D = .zero
    @State private var startPosition: Point3D? = nil
    @State private var rotation: Angle = .zero
    @State private var accumulatedRotation: Angle = .zero
    @State private var startRotation: Angle? = nil

    func body(content: Content) -> some View {
        content
            .onAppear {
                position = initialPosition
            }
            .rotation3DEffect(rotation + accumulatedRotation, axis: .y)
            .scaleEffect(scale)
            .position(x: position.x, y: position.y)
            .offset(z: position.z)

            // Enable people to move the model anywhere in their space.
            .simultaneousGesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                .handActivationBehavior(.pinch)
                .onChanged { value in
                    if let startPosition {
                        let delta = value.location3D - value.startLocation3D
                        position = startPosition + delta
                    } else {
                        startPosition = position
                    }
                }
                .onEnded { _ in
                    startPosition = nil
                }
            )

            // Enable people to scale the model within certain bounds.
            .simultaneousGesture(MagnifyGesture()
                .onChanged { value in
                    if let startScale {
                        scale = max(0.1, min(3, value.magnification * startScale))
                    } else {
                        startScale = scale
                    }
                }
                .onEnded { value in
                    startScale = scale
                }
            )
        
            // Enable people to rotate the model.
            .simultaneousGesture(
                RotationGesture()
                    .onChanged { value in
                        if let startRotation = startRotation {
                            // Keep updating the rotation as it progresses
                            rotation = startRotation + value
                        } else {
                            // Set startRotation only once when the gesture begins
                            startRotation = rotation
                        }
                    }
                    .onEnded { _ in
                        // Update startRotation after the gesture ends, maintaining continuous rotation
                        startRotation = rotation
                    }
            )
        
            .onChange(of: axZoomIn) {
                scale = max(0.1, min(3, scale + 0.2))
                startScale = scale
            }
            .onChange(of: axZoomOut) {
                scale = max(0.1, min(3, scale - 0.2))
                startScale = scale
            }
    }
}
