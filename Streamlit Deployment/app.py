import streamlit as st
import pandas as pd
import joblib

st.set_page_config(
    page_title="SmartSpec Analytics",
    page_icon="📱",
    layout="wide"
)

st.markdown("""

""", unsafe_allow_html=True)


@st.cache_resource
def load_model():
    return joblib.load("price_prediction_model.pkl")


@st.cache_data
def load_data():
    return pd.read_excel("Dataset.xlsx")


model = load_model()
df = load_data()

import re


# Convert the raw display text into simpler display categories
def extract_display_type(display):

    display = str(display).upper()

    if "DYNAMIC AMOLED" in display:
        return "Dynamic AMOLED"

    elif "SUPER AMOLED" in display:
        return "Super AMOLED"

    elif "AMOLED" in display:
        return "AMOLED"

    elif "POLED" in display:
        return "P-OLED"

    elif "OLED" in display:
        return "OLED"

    elif "IPS LCD" in display:
        return "IPS LCD"

    elif "IPS" in display:
        return "IPS"

    elif "LCD" in display:
        return "LCD"

    elif re.search(r'HD\+|FHD\+|FULL HD\+|FULL HD|HD DISPLAY', display):
        return "LCD (Unspecified)"

    else:
        return "Other"


df["Display_Type"] = df["Display"].apply(extract_display_type)


# Count only the rear camera specifications from the raw camera field
def rear_camera_count(camera):

    camera = str(camera)

    rear = camera.split("|")[0]

    return len(re.findall(r"(\d+(?:\.\d+)?)MP", rear))


df["Rear_Camera_Count"] = df["Camera"].apply(rear_camera_count)


with st.container():

    st.title("📱 SmartSpec Analytics")

    st.markdown("""

### Machine Learning Based Smartphone Price Prediction

Predict smartphone prices from hardware specifications using an
**XGBoost Regressor** trained on Flipkart smartphone data.

**Tech Stack:** Python • Pandas • Scikit-Learn • XGBoost • Streamlit
""")

    st.divider()


st.sidebar.header("Enter Smartphone Specifications")

brand = st.sidebar.selectbox(
    "Brand",
    sorted(df["Brand"].unique())
)

processor = st.sidebar.selectbox(
    "Processor",
    sorted(df["Processor_Clean"].unique())
)

ram = st.sidebar.selectbox(
    "RAM (GB)",
    sorted(df["RAM"].unique())
)

storage = st.sidebar.selectbox(
    "Storage (GB)",
    sorted(df["Storage"].unique())
)

battery = st.sidebar.number_input(
    "Battery (mAh)",
    min_value=1000,
    max_value=10000,
    value=5000
)

display_size = st.sidebar.number_input(
    "Display Size (inch)",
    min_value=4.0,
    max_value=8.5,
    value=6.5
)

display_type = st.sidebar.selectbox(
    "Display Type",
    sorted(df["Display_Type"].unique())
)

rear_camera = st.sidebar.number_input(
    "Rear Camera (MP)",
    min_value=2,
    max_value=300,
    value=50
)

front_camera = st.sidebar.number_input(
    "Front Camera (MP)",
    min_value=0,
    max_value=100,
    value=16
)

rear_camera_count = st.sidebar.selectbox(
    "Rear Camera Count",
    sorted(df["Rear_Camera_Count"].unique())
)

predict = st.sidebar.button(
    "💰 Predict Price",
    use_container_width=True
)


if predict:

    input_df = pd.DataFrame({

        "RAM":[ram],

        "Storage":[storage],

        "Battery":[battery],

        "Display_Size":[display_size],

        "Rear_Main_MP":[rear_camera],

        "Front_MP":[front_camera],

        "Rear_Camera_Count":[rear_camera_count],

        "Brand":[brand],

        "Processor_Clean":[processor],

        "Display_Type":[display_type]

    })

    prediction = model.predict(input_df)[0]

    st.success("Prediction Successful")

    prediction_container = st.container(border=True)

    with prediction_container:

        st.subheader("💰 Predicted Smartphone Price")

        if predict:
            st.metric(
                label="Estimated Price",
                value=f"₹ {prediction:,.0f}"
            )
        else:
            st.info("Enter smartphone specifications and click **Predict Price**.")


st.divider()

st.subheader("📈 Model Performance")

col1, col2, col3 = st.columns(3)

with col1:
    st.metric(
        "R² Score",
        "97.38%"
    )

with col2:
    st.metric(
        "MAE",
        "₹2,946"
    )

with col3:
    st.metric(
        "RMSE",
        "₹5,580"
    )

st.divider()

with st.container(border=True):

    st.subheader("📂 Dataset Preview")

    st.write(f"Rows: {df.shape[0]} | Columns: {df.shape[1]}")

    st.dataframe(
        df.head(10),
        use_container_width=True
    )

st.divider()

with st.container(border=True):

    st.subheader("📈 Feature Importance")

    st.image(
        "feature_importance.png",
        use_container_width=True
    )

st.divider()

with st.container(border=True):

    st.subheader("ℹ️ About Project")

    st.markdown("""

This project predicts smartphone prices using Machine Learning.

### Workflow

- Web Scraping
- Data Cleaning
- Exploratory Data Analysis
- SQL Business Analysis
- Feature Engineering
- Machine Learning
- Hyperparameter Tuning
- Model Explainability

**Best Model:** XGBoost Regressor
""")

st.caption(
    "Developed by Karan Kukadiya | SmartSpec Analytics | Data Analytics Project"
)
