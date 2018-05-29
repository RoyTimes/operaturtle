var fs = require('fs');
var readline = require('readline');

var rl = readline.createInterface({
    input: fs.createReadStream("hundred.csv")
});

let keepcol = []
var lines = 0;

let getline = (line) => {
    let str = ""
    let linearr = line.split(",")

    for (let index in linearr) {
        if (keepcol.indexOf(index) > 0) {
            str += "," + linearr[index]
        }
    }
    str += "\n"
    return str;
}

rl.on('line', (line) => {
    // console.log(line)
    console.log(lines ++)

    if (lines == 1) {
        let headers = line.split(",");
        rl.pause();

        for (let index in headers) {

            if (    headers[index].indexOf("is_range_valid") < 0 &&    
                    headers[index].indexOf("killer_participant_id") < 0 &&
                    headers[index].indexOf("killer") < 0 &&
                    headers[index].indexOf("killer_rank") < 0 &&
                    headers[index].indexOf("killer_user_nickname") < 0 &&
                    headers[index].indexOf("killer_user_profile_url") < 0 &&
                    headers[index].indexOf("victim_participant_id") < 0 &&
                    headers[index].indexOf("victim_rank") < 0 &&
                    headers[index].indexOf("victim_user_nickname") < 0 &&
                    headers[index].indexOf("victim_user_profile_url") < 0 &&
                    parseInt(headers[index].split('_')[1]) < 100
                ) {
                
                keepcol.push(index)   
            }
        }
        
        rl.pause();
        fs.appendFile('out.csv', getline(line), (err) => {
            if (err) console.error(err)
            else rl.resume();
        })

    } else {
        rl.pause();
        fs.appendFile('out.csv', getline(line), (err) => {
            if (err) console.error(err)
            else rl.resume();
        })
    }
})
.on('end', () => {
    rl.close();
})
