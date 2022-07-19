const express = require('express');
const hbs = require('hbs');
const wax = require('wax-on');
// call function immediately as handlebars helpers return a function and tell it where to look
require('handlebars-helpers')({
    'handlebars': hbs.handlebars
})
require('dotenv').config();
const mysql2 = require('mysql2/promise');  // to use await/async, we must
// use the promise version of mysql2
//mysql2 comes in 2 variants; one uses callback function and the other uses promises 


const app = express();
app.set('view engine', 'hbs');
wax.on(hbs.handlebars);
wax.setLayoutPath('./views/layouts');

// enable using forms
app.use(express.urlencoded({
    'extended': false
}));

//if root user is compromised, all the databases on the same server will be compromised

async function main() {
    const connection = await mysql2.createConnection({
        'host': process.env.DB_HOST,  // host -> ip address of the database server
        'user': process.env.DB_USER,
        'database': process.env.DB_DATABASE,
        'password': process.env.DB_PASSWORD
    })

    app.get('/error', async function (req, res) {
        res.status(500);
        res.send('something went wrong')
    })

    app.get('/actors', async function (req, res) {
        // connection.execute returns an array of results
        // the first element is the table that we selected
        // the second element onwards are some housekeeping data
        // the first element will be stored in actors variable
        const [actors] = await connection.execute("SELECT * FROM actor");

        // short form for:
        // const results = await connection.execute("SELECT * FROM actor");
        // const actors = results[0];

        res.render('actors.hbs', {
            'actors': actors
        })
    })

    app.get('/staffs', async function (req, res) {
        const [staffs] = await connection.execute('select * from staff');
        res.render('staffs.hbs', {
            'staffs': staffs
        })
    })

    app.get('/search', async function (req, res) {
        //define the 'get all results query'
        let query = 'select * from actor where 1'
        // 1 means true <= select * from actor where true (all rows)
        let [actors] = await connection.execute(query); // => connection will return an array of results
        let bindings = []

        //prepared statement cannot directly load => dynamic values will be replaced with (?)
        //replacement takes place on my sql server -> will be locked into select * 
        //if req.query.first_name is not falsely
        // undefined, null, empty string, 0 => falsely

        // const query = 'insert into actors(first_name, last_name) VALUES (?,?)'
        //question mark is a placeholder => bindings will replace the ?
        //connection.execute(query, ['zoe', 'tay'])


        // replacement happens on NODEJS side, NOT EXPRESS

        // prepared query -> protect your wbsite from attacks
        if (req.query.first_name) {
            query += `AND first_name LIKE ?;`
            bindings.push('%' + req.query.first_name + '%')
        }


        if (req.query.last_name) {
            query += `AND last_name LIKE '?`;
            bindings.push('%' + req.query.last_name) + '%'
        }


        // whatever is inside will be treated as string

        console.log(query)
        res.render('search.hbs', {
            actors: actors
        })
    })

    app.get('/actors/create', async function (req, res) {
        res.render('create_actor');
    })

    app.post('/actors/create', async function (req, res) {
        //sample query
        //insert into actor (first_name, last_name) values('fann', 'wong);
        const query = "insert into actor(first_name, last_name) values(?, ?)";
        const bindings = [req.body.first_name, req.body.last_name];
        await connection.execute(query, bindings);
        res.redirect('/actors');
        // res.send(req.body)
    })

    app.get('/actors/:actor_id/update', async function (req, res) {
        //replacement only done when sql needs the data
        // select is the only function that can get back data
        const actorId = parseInt(req.params.actor_id); //=? removes the chance that req.params contains special characters
        const query = "select * from actor where actor_id = ?";
        const [actors] = await connection.execute(query, [actorId]);
        const actorToUpdate = actors[0]; //since we are only expecting one result, just take the first index
        res.render('update_actor', {
            actor: actorToUpdate
        })

    })

    app.post('/actors/:actor_id/update', async function (req, res) {
        if (req.body.first_name.length > 45) {
            res.status(400);
            res.send('invalid request'); //=> res.send will nOT end the function -> put return
            return;
        }
        //sample query
        //update actor set first_name="zoe2", last_name="tay2" where actor_id = 202;
        const query = `update actor set first_name=?, last_name=? where actor_id = ?;`
        //if get binding error; number of elements in binding is wrong or one element is undefined
        const bindings = [req.body.first_name, req.body.last_name, parseInt(req.params.actor_id)];
        await connection.execute(query, bindings);
        res.redirect('/actors');
    })

    app.post('/actors/:actor_id/delete', async function (req, res) {
        const query = 'delete from actor where actor_id = ?';
        const bindings = [parseInt(req.params.actor_id)];
        await connection.execute(query, bindings);
        res.redirect('/actors')
    })

    app.get('/categories', async function (req, res) {
        // const [categories] = await connection.execute("select * from category");
        let additionalQuery = " ";
        let bindings = [];
        if (req.query.name) {
            additionalQuery += "AND name LIKE ?";
            bindings.push('%' + req.query.name + '%')
        };
        let query = "select * from category where 1" + additionalQuery + " order by name";
        console.log(query)
        let [categories] = await connection.execute(query, bindings);
        res.render('category', {
            category: categories
        })
    })

    app.get('/categories/create', async function (req, res) {
        res.render('create_category')
    })

    app.post('/categories/create', async function (req, res) {
        const query = "insert into category(name) values (?)";
        const bindings = [req.body.name];
        await connection.execute(query, bindings);
        res.redirect('/categories')
    })

    // app.get('/categories/search', async function(req,res){
    //     const query = "select * from category where 1";
    //     const bindings = [];
    //     let [categories] = await connection.execute(query);
    //     if (req.query.name){
    //         query += "AND name LIKE ?";
    //         bindings.push('%' + req.query.name + '%')
    //     };
    //     res.render()
    // })

    app.get('/categories/update/:category_id', async function (req, res) {
        let catID = parseInt(req.params.category_id);
        let query = `select * from category where category_id = ${catID}`
        let [category] = await connection.execute(query);
        categoryToUpdate = category[0];
        res.render('update_category', {
            category: categoryToUpdate
        })
    })

    app.post('/categories/update/:category_id', async function (req, res) {
        // validation for 25 chars or shorter
        try {
            const query = `update category set name=? where category_id = ?`;
            const bindings = [req.body.name, parseInt(req.params.category_id)];
            await connection.execute(query, bindings);
            res.redirect('/categories')
        } catch (e) {
            console.log(e);
            res.redirect('/error')
        }
    })

    // app.post('/categories/delete/:category_id', async function (req, res) {
    //     const query = "delete from category where category_id = ?";
    //     const bindings = [parseInt(req.params.category_id)];
    //     await connection.execute(query, bindings);
    //     res.redirect('/categories');
    // })

    app.get('/categories/delete/:category_id', async function (req, res) {
        const query = "select * from category where category_id = ?";
        const [categories] = await connection.execute(query, [parseInt(req.params.category_id)]);
        const categoryToDelete = categories[0];
        res.render('confirm_delete_category', {
            'category': categoryToDelete
        })
    })

    app.post('/categories/delete/:category_id', async function (req, res) {
        const query = "delete from category where category_id = ?";
        const bindings = [parseInt(req.params.category_id)];
        await connection.execute(query, bindings);
        res.redirect('/categories');

        // dealing with foreign keys
        // find all the films which have category_id equal to the one that you want to delete
        // const deleteQuery = 'delete from film_category where category_id == ?';
        // await connection.execute(deleteQuery, [parseInt(req.params, category_id)])
    })

    app.get('/films', async function(req,res){
        const[films] = await connection.execute(`select film_id, title, description, language.name as language from film 
        join language 
        on film.language_id = language.language_id`);
        res.render('films', {
            films: films
        })
    })

    app.get('/films/create', async function (req, res) {
        const [languages] = await connection.execute(
            'select * from language'
        );
        res.render('create_film', {
            languages: languages
        })
    })

    app.post('/films/create', async function (req, res) {
        // insert into film (title, description, language_id) values('the lord of the ring', 'hello', 1);
        await connection.execute('insert into film (title, description, language_id) values(?, ?, ?)',
            [req.body.title, req.body.description, req.body.language_id]);
        res.redirect('/films')
    });

    app.get('/films/:film_id/update', async function(req,res){
        const [languages] = await connection.execute(
            'select * from language'
        );
        const [films] = await connection.execute(
            'select * from film where film_id = ?',
            [parseInt(req.params.film_id)]
        );
        const filmToUpdate = films[0]
        res.render('update_film', {
            film: filmToUpdate,
            languages: languages
        })
    })

    // app.get('/films/:film_id/update', async function (req, res) {
    //     const [languages] = await connection.execute("SELECT * from language");
    //     const [films] = await connection.execute("SELECT * from film where film_id = ?",
    //         [parseInt(req.params.film_id)]);
    //     const filmToUpdate = films[0];
    //     res.render('update_film',{
    //         'film':filmToUpdate,
    //         'languages':languages
    //     })

    // })

    app.post('/films/:film_id/update', async function(req,res){
        //sample query
        //update film set title='asd asd', description='asd2 asd2', language_id=3 where film_id=1;
        await connection.execute(
            `update film set title =?, description =?, language_id=? where film_id=?`,
            [req.body.title, req.body.description, parseInt(req.body.language_id), req.params.film_id]
        );
        res.redirect('/films')
    })

};
main();


app.listen(3000, function () {
    console.log("server has started")
})