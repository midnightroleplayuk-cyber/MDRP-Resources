// const fs = require("fs");
// const path = require("path");

// on("gg_boosting:server:uploadToFivemanage", async (fileName) => {
//     const resourcePath = GetResourcePath(GetCurrentResourceName());
//     const filePath = path.join(
//         resourcePath,
//         "web",
//         "dist",
//         "vehicle_images",
//         `${fileName}.webp`,
//     );

//     try {
//         const file = await fs.promises.readFile(filePath);

//         // convert to ArrayBuffer (safe across FiveM export bridge)
//         const arrayBuffer = file.buffer.slice(
//             file.byteOffset,
//             file.byteOffset + file.byteLength,
//         );

//         console.log("File Name", fileName);

//         exports.fmsdk
//             .uploadImage(arrayBuffer, {
//                 fileName: `${fileName}.webp`,
//                 metadata: { cid: Number(fileName) },
//             })
//             .then((imageData) => {
//                 console.log("Uploaded: " + imageData.url);
//             });
//     } catch (err) {
//         console.error("Upload failed:", err);
//     }
// });
