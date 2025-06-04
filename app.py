from flask import Flask, render_template, request, redirect, session, flash
import mysql.connector
from datetime import datetime
app = Flask(__name__)
app.secret_key = 'vnit_hms_secret'

# MySQL DB Connection
db = mysql.connector.connect(
    host="hostname",
    user="username",
    password="password",
    database="hms_vnit"
)
cursor = db.cursor(dictionary=True)

# ---------------------- LOGIN ----------------------
@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        student_id = request.form['student_id']
        password = request.form['password']
        cursor.execute("SELECT * FROM Students WHERE student_id = %s AND password = %s", (student_id, password))
        user = cursor.fetchone()
        if user:
            session['student_id'] = user['student_id']
            session['name'] = user['name']
            return redirect('/home')
        else:
            flash("Incorrect ID or password", "danger")
    return render_template("index.html")

@app.route('/home')
def home():
    if 'student_id' not in session:
        return redirect('/')
    return render_template("home.html", name=session['name'])

@app.route('/logout')
def logout():
    session.clear()
    return redirect('/')

# ---------------------- APPOINTMENTS ----------------------
@app.route('/appointments', methods=['GET', 'POST'])
def appointments():
    if request.method == 'POST':
        student_id = request.form['student_id']
        doctor_id = request.form['doctor_id']
        time = request.form['time']
        
        # Check doctor availability
        cursor.execute("SELECT available FROM Doctors WHERE doctor_id = %s", (doctor_id,))
        doctor = cursor.fetchone()
        if not doctor or not doctor['available']:
            flash("Doctor not available at the moment!", "danger")
            return redirect('/appointments')
        
        # Insert appointment
        cursor.execute("""INSERT INTO Appointments 
            (student_id, doctor_id, appointment_time, status) 
            VALUES (%s, %s, %s, 'Scheduled')""", (student_id, doctor_id, time))
        
        # Insert notification
        message = "Your appointment has been scheduled successfully."
        cursor.execute("""INSERT INTO Notifications 
            (student_id, message, timestamp) 
            VALUES (%s, %s, %s)""", (student_id, message, datetime.now()))
        
        
        db.commit()
        flash("Appointment booked and notification sent.", "success")
        return redirect('/appointments')

    cursor.execute("""SELECT a.*, s.name AS student_name, d.name AS doctor_name 
                      FROM Appointments a 
                      JOIN Students s ON a.student_id = s.student_id 
                      JOIN Doctors d ON a.doctor_id = d.doctor_id""")
    data = cursor.fetchall()

    cursor.execute("SELECT * FROM Doctors")
    doctors = cursor.fetchall()
    return render_template("appointments.html", appointments=data, doctors=doctors)

# ---------------------- DOCTOR AVAILABILITY ----------------------
@app.route('/doctor_availability')
def availability():
    cursor.execute("SELECT * FROM Doctors")
    doctors = cursor.fetchall()
    return render_template("doctor_availability.html", doctors=doctors)
# ---------------------- HEALTH RECORD DISPLAY ----------------------
@app.route('/health_records')
def records():
    cursor.execute("""SELECT s.name, h.diagnosis, h.treatment, h.record_date 
                      FROM HealthRecords h 
                      JOIN Students s ON h.student_id = s.student_id""")
    records = cursor.fetchall()
    return render_template("health_records.html", records=records)

# ---------------------- EMERGENCY ALERTS ----------------------
@app.route('/emergency_alerts', methods=['GET', 'POST'])
def emergency():
    if request.method == 'POST':
        student_id = request.form['student_id']
        message = request.form['message']
        now = datetime.now()
        cursor.execute("INSERT INTO EmergencyAlerts (student_id, alert_message, alert_time) VALUES (%s, %s, %s)",
                       (student_id, message, now))
        db.commit()
        return redirect('/emergency_alerts')
    cursor.execute("SELECT * FROM EmergencyAlerts")
    alerts = cursor.fetchall()
    return render_template("emergency_alerts.html", alerts=alerts)

# ---------------------- NOTIFICATIONS ----------------------
@app.route('/notifications')
def notifications():
    if 'student_id' not in session:
        return redirect('/')
    cursor.execute("""SELECT * FROM Notifications 
                      WHERE student_id = %s ORDER BY timestamp DESC""", (session['student_id'],))
    notes = cursor.fetchall()
    return render_template("notifications.html", notifications=notes)

# ---------------------- STUDENT ACCOUNTS ----------------------
@app.route('/account')
def account():
    cursor.execute("SELECT * FROM Students")
    students = cursor.fetchall()
    return render_template("account.html", students=students)

# ---------------------- RUN ----------------------
if __name__ == '__main__':
    app.run(debug=True)
