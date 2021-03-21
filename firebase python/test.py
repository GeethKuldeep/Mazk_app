import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate("secrets/serviceAccountKey.json")

firebase_admin.initialize_app(cred)

db = firestore.client()

reference_for_update = db.collection(u'Vendors').document(u'ehQnQQYcm6tiU3MmqgtW')

reference_for_read = db.collection(u'Vendors')

def extract(ref):
    docs = ref.stream()
    for doc in docs:
        if doc.id == "ehQnQQYcm6tiU3MmqgtW":
           return int(f'{doc.to_dict()["Current_strength"]}')


# reference_for_update.update({
#     u'Current_present': 59
# })

def increment():
    value = extract(reference_for_read)
    value+=1
    reference_for_update.update({
        u'Current_strength':value
    })

increment()