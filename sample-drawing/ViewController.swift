import UIKit

struct Drawing {
    var color: UIColor
    var points: [CGPoint]

    init() {
        color = .black
        points = []
    }
}

class ViewController: UIViewController {

    @IBOutlet private weak var canvasView: CanvasView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func tappedClearCanvasButton(_ sender: Any) {
        canvasView.clearCanvas()
    }

}

class CanvasView: UIView {
    private var currentDrawing: Drawing?
    private var finishedDrawings: [Drawing] = []
    private let currentColor: UIColor = .black

    func clearCanvas() {
        currentDrawing = nil
        finishedDrawings = []
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for drawing in finishedDrawings {
            drawing.color.setStroke()
            stroke(drawing: drawing)
        }

        if let drawing = currentDrawing {
            drawing.color.setStroke()
            stroke(drawing: drawing)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        currentDrawing = Drawing()
        currentDrawing?.points.append(location)
        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        currentDrawing?.points.append(location)
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if var drawing = currentDrawing {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            drawing.points.append(location)
            finishedDrawings.append(drawing)
        }
        currentDrawing = nil
        setNeedsDisplay()
    }

    private func stroke(drawing: Drawing) {
        let path = UIBezierPath()
        path.lineWidth = 10.0
        path.lineCapStyle = .round
        path.lineJoinStyle = .round

        for (i, point) in drawing.points.enumerated() {
            switch i {
            case 0:
                path.move(to: point)
                break
            default:
                path.addLine(to: point)
            }
        }
        path.stroke()
    }
}
