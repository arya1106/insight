async function pullData(centerPoint, radians) {
    let response = await fetch("138.197.104.208/query", {
        method: "POST",
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
            centerPoint: centerPoint,
            radians: radians
        })
    });
    return response.json();
}