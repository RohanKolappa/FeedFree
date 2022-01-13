from flask import request, jsonify

from feedfreeservice import app
from feedfreeservice import db

import json


@app.route('/feedfree/organizations/<city>', methods=['GET'])
def get_organization_list(city, *args, **kwargs):
    sql_query = f'''SELECT organization_id, name, address, image_url, 
                           food_status, email_address, mobile_number, comment
                  FROM organizations WHERE city = "{city}";'''
    orgs = db.engine.execute(sql_query)
    all_orgs=[]
    for org in orgs:
        all_orgs.append({'id': org.organization_id, 'name':org.name, 'address':org.address, 'image_url':org.image_url, 'food_status': org.food_status, 'email_address': org.email_address, 'mobile_number': org.mobile_number, 'comment': org.comment})

    return jsonify({'organizations': all_orgs})


@app.route('/feedfree/user', methods=['POST'])
def validate_user(*args, **kwargs):
    request_data = request.get_json(force=True)
    #request_data = request.json
    if request_data is None:
        request_data = {}
    print(request_data)
    user = request_data['user']
    password = request_data['password']
    sql_query = f'SELECT count(*) FROM users WHERE user = "{user}" AND password = "{password}";'
    result = db.engine.execute(sql_query)
    count = result.first()[0]
    print(count)
    if count == 0:
        return jsonify({'status_code': 0})
    else:
        return jsonify({'status_code': 1})


@app.route('/feedfree/organizations/edit', methods=['POST'])
def modify_organization(*args, **kwargs):
    try:
        request_data = request.get_json(force=True)
        if request_data is None:
            request_data = {}
        print(request_data)
    
        id = request_data['id']
        name = request_data['name']
        address = request_data['address']
        food_status = request_data['food_status']
        comment = request_data['comment']
        sql_query = f'''UPDATE organizations 
                  SET name = "{name}",
                      address = "{address}",
                      food_status = {food_status},
                      comment = "{comment}"
                  WHERE organization_id = {id};'''
        result = db.engine.execute(sql_query)
        db.session().commit()
        db.session().close()

        return jsonify(success=f'Successfully modified organization.'), 200
    except Exception as e:
        print(e)
        return jsonify(error=f'Unable to modify organization'), 500


@app.route('/feedfree/organizations/register', methods=['POST'])
def register_organization(*args, **kwargs):
    try:
        request_data = request.get_json(force=True)
        if request_data is None:
            request_data = {}
        print(request_data)

        name = request_data['name']
        address = request_data['address']
        address_more = request_data['address_more']
        city = request_data['city']
        state = request_data['state']
        zip = request_data['zip_code']
        land_number = request_data['land_number']
        mobile_number = request_data['mobile_number']
        email = request_data['email_address']
        source = request_data['source']
        password = ''
        org_id = 0

        sql_query = f'''INSERT INTO  organizations(
			name, address, address_more, city, state, zip_code,
			mobile_number, land_number, email_address)
                        VALUES("{name}", "{address}", "{address_more}", "{city}",
			"{state}", "{zip}", "{mobile_number}", "{land_number}",
			"{email}");'''
        result = db.engine.execute(sql_query)
        org_id = result.lastrowid
        print(org_id)
        register_user(email, org_id, source, password)

        return jsonify(success=f'Successfully registered organization.'), 200
    except Exception as e:
        print(e)
        return jsonify(error=f'Unable to register organization'), 500


def register_user(email, org_id, source, password):
    sql_query = f'''INSERT INTO  users(	
                  email_address, organization_id, password, source)
                  VALUES("{email}", {org_id}, "{password}", "{source}");'''
    result = db.engine.execute(sql_query)
